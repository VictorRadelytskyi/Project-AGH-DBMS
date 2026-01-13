import pymssql
import os, random
import datetime as dt

WAGE_COST = 60
ASSEMBLERS = [3, 4, 5, 6, 7, 11]
PRICE_MARKUP = 0.3

CONN = None
CURSOR = None

def db_connect():
    conn = pymssql.connect(
        server='janilowski.database.windows.net',
        database='dev',
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
    )

    cursor = conn.cursor(as_dict=True)
    return conn, cursor

def random_date(start: dt.datetime, end: dt.datetime) -> dt.datetime:

    delta = end - start
    int_delta = delta.days
    random_day = random.randrange(int_delta)
    return start + dt.timedelta(days = random_day)

def execute_query(sql: str, params: tuple) -> list:

    try:

            # Add the order
        CURSOR.execute(sql, params)
            
        try:
            result = CURSOR.fetchall()
        except:
            # print("Warning: no results for the query")
            result = None

        CONN.commit()
    
    except Exception as e:
        print(f"Query failed: {e}")
        return None

    return result

def get_all_orders() -> list:

    sql = """SELECT *
             FROM Orders
             WHERE FulfillmentFinish IS NULL
             ORDER BY OrderDate ASC;
    """

    param_list = ()

    return execute_query(sql, param_list)

def get_order_products(order_id: int) -> list:

    sql = """SELECT *
             FROM OrderDetails
             WHERE OrderID = %d;
    """

    param_list = (order_id)

    return execute_query(sql, param_list)

def get_product_recipe(product_id: int) -> list:

    sql = """SELECT *
            FROM ProductRecipes pr
            INNER JOIN Products p ON p.ProductRecipesID = pr.ID
            WHERE p.ID = %d;
    """

    param_list = (product_id)

    return execute_query(sql, param_list)


def get_recipe_ingredients(recipe_id: int) -> list:

    sql = """SELECT *
            FROM RecipeIngredients
            WHERE ProductRecipeID = %d;
    """

    param_list = (recipe_id)

    return execute_query(sql, param_list)

def consume_components_and_labour(recipe: dict, ingredients_list: list, quantity: int) -> None:

    total_cost = 0

    # Go through all components and consume
    for ingredient in ingredients_list:

        sql = """
            DECLARE @AvgCost DECIMAL(10,2);

            EXEC ConsumeComponentStockFromInventory 
            @ComponentID = %d, 
            @QuantityRequired = %d,
            @AverageUnitPrice = @AvgCost OUTPUT;

            SELECT @AvgCost AS [ActualCostPerUnit];
        """

        param_list = (ingredient['ComponentID'], quantity)

        result = execute_query(sql, param_list)

        components_cost = result[0]['ActualCostPerUnit'] * ingredient['QuantityRequired']

        total_cost += components_cost

    total_cost += recipe['LabourHours'] * WAGE_COST

    return float(total_cost)

def start_order_fulfillment(order_id: int, order_date: dt.datetime) -> None:

    sql = """
        EXEC dbo.StartOrderFulfillment
        @OrderID = %d,
        @AssemblerID = %d;
    """

    param_list = (order_id, random.choice(ASSEMBLERS))

    try:
        execute_query(sql, param_list)
    except Exception as e:
        print("Warning: could not start order fullfillment because:\n", e)
        return

    sql = """
        UPDATE Orders
        SET FulfillmentStart = %s
        WHERE ID = %d;
    """

    param_list = (random_date(order_date, order_date + dt.timedelta(days=4)), order_id)

    execute_query(sql, param_list)

def end_order_fulfillment(order_id: int, order_date: dt.datetime) -> None:

    sql = """
        UPDATE Orders
        SET FulfillmentFinish = %s
        WHERE ID = %d;
    """

    param_list = (random_date(order_date + dt.timedelta(days=4), order_date + dt.timedelta(days=8)), order_id)

    execute_query(sql, param_list)

def restock_component(component_id: int, quantity: int, order_date: dt.datetime) -> None:

    sql = """
        SELECT *
        FROM Components
        WHERE ID = %d;
    """

    param_list = (component_id)

    result = execute_query(sql, param_list)

    sql = """
        DECLARE @NewInventoryID INT;

        EXEC AddComponentInventory 
            @componentID = %d, 
            @inventoryDate = %s, 
            @unitPrice = %d,
            @unitsInStock = %d,
            @ID = @NewInventoryID OUTPUT;
    """

    restock_date = random_date(order_date - dt.timedelta(days=4), order_date)
    restock_quantity = quantity + int(random.paretovariate(1.16) * 200) * int(random.random() > 0.5)

    discount = 0.15 if restock_quantity > 500 else 0.10 if restock_quantity > 200 else 0
    discount += random.choice([0.02, 0.05, 0.1, 0.15]) * int(random.random() > 0.2)
    restock_price = float(result[0]['UnitPrice']) * (1 - discount)

    param_list = (component_id, restock_date, restock_price, restock_quantity)

    execute_query(sql, param_list)

def set_unitprice_in_orderdetails(order_id: int, product_id: int, price: float, quantity: int) -> None:

    sql = """
        UPDATE OrderDetails
        SET UnitPrice = %d,
        QuantityFulfilled = %d
        WHERE OrderID = %d
        AND ProductID = %d;
    """

    param_list = (price, quantity, order_id, product_id)

    execute_query(sql, param_list)

def fulfill_full_order(curr_order: dict) -> None:

    # 0. Set fulfillment date
    start_order_fulfillment(curr_order['ID'], curr_order['OrderDate'])

    # 1. Get all order products
    products = get_order_products(curr_order['ID'])

    for product in products:
        curr_product_id = product['ProductID']

        # 2. Get recipe
        recipe = get_product_recipe(curr_product_id)
        ingredients = get_recipe_ingredients(recipe[0]['ID'])

        # 80% chance that components were restocked before order

        if random.random() > 0.2:

            for ingredient in ingredients:
                restock_component(ingredient['ComponentID'], product['Quantity'] * ingredient['QuantityRequired'], curr_order['OrderDate'])          

        # 3. Consume components for each recipe item
        production_unit_cost = consume_components_and_labour(recipe[0], ingredients, product['Quantity'])

        # 4. Update UnitPrice and q in orderdetails
        set_unitprice_in_orderdetails(curr_order['ID'], curr_product_id, production_unit_cost * (1 + PRICE_MARKUP), product['Quantity'])

    # 5. All products manufactured, set fulfillment finish date
    end_order_fulfillment(curr_order['ID'], curr_order['OrderDate'])


def main() -> None:

    global CONN, CURSOR

    CONN, CURSOR = db_connect()

    try:
    
        orders = get_all_orders()

        for order in orders:

            print(f"Fulfilling order: {order['ID']}...")

            fulfill_full_order(order)

            print(f"Finished order: {order['ID']}")

        print(f"All finished. {len(orders)} orders fulfilled")

    finally:
        CONN.close()
    
if __name__=="__main__":
    # Timer
    import time
    start = time.perf_counter()
    main()
    end = time.perf_counter()
    print(f"Elapsed time: {end - start:.6f} seconds")
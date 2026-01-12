import pymssql
import os, random, json
import datetime as dt

NO_OF_RECORDS = 100
CUSTOMERS = [i for i in range(1, 11)]
SALES_EMPLOYEES = [2, 8]
ASSEMBLERS = [3, 4, 5, 6, 7, 11]
PRODUCTS = [i for i in range(1, 12)]
DATE_START = '2020-01-01'
DATE_END = '2024-01-01'
FREIGHT_AVG = 15.0

def db_connect():
    conn = pymssql.connect(
        server='janilowski.database.windows.net',
        database='dev',
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
    )

    cursor = conn.cursor()
    return conn, cursor

def random_date(start: dt.datetime, end: dt.datetime) -> dt.datetime:

    delta = end - start
    int_delta = delta.days
    random_day = random.randrange(int_delta)
    return start + dt.timedelta(days = random_day)

def random_product_json() -> str:

    product_list = []

    n = min(int(random.paretovariate(1.16)), 10) # Mean order size = 2.3
    products = random.sample(PRODUCTS, n)

    for i in range(n):

        random_quantity = max(int(random.paretovariate(1.16) * 0.6), 1) # Mean product quantity = 2

        product_list.append(
            {
                "ProductID": products[i],
                "Quantity": random_quantity
            }
        )

    return json.dumps(product_list)

def random_freight_cost():

    if random.random() < 0.70:
        premium = random.uniform(-0.10, 0.10)
    else:
        premium = random.uniform(1, 4)
        
    return round(FREIGHT_AVG * (1 + premium), 2)

def execute_query(sql: str, sql2: str, param_list: list) -> None:

    """
        EXEC PlaceFullOrder 
        @CustomerID = 1, 
        @DealerEmployeeID = 2,
        @AssemblerEmployeeID = 3,
        @Freight = 15.50,
        @ItemsJson = N'[{"ProductID": 10, "Quantity": 2}, {"ProductID": 12, "Quantity": 1}]';
    """

    conn, cursor = db_connect()

    try:

        for p in param_list:

            # Add the order
            cursor.execute(sql, p)
            
            new_id = cursor.fetchone()[0]
            print(new_id)

            # Update dates to random date in the past
            cursor.execute(sql2, (random_date(dt.datetime.fromisoformat(DATE_START), dt.datetime.fromisoformat(DATE_END)), new_id))
                
        conn.commit()
    finally:
        conn.close()

def main():

    sql = """EXEC PlaceFullOrder 
        @CustomerID = %d, 
        @DealerEmployeeID = %d,
        @AssemblerEmployeeID = %d,
        @Freight = %d,
        @ItemsJson = %s"""
    
    sql2 = """
        UPDATE [dbo].[Orders]
        SET OrderDate = %s
        WHERE ID = %d
    """

    param_list = []

    for _ in range(NO_OF_RECORDS):

        param_list.append(
            (
                random.choice(CUSTOMERS),
                random.choice(SALES_EMPLOYEES),
                random.choice(ASSEMBLERS),
                random_freight_cost(),
                random_product_json(),
            )
        )

    execute_query(sql, sql2, param_list)

if __name__=="__main__":
    main()
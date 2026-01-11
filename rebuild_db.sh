#!/bin/bash

# --- Configuration ---
DB_SERVER="janilowski.database.windows.net"
DB_NAME="dev"
DB_USER="..." # Write your own username here

DB_TABLES_FILE="pbd_projekt.sql" # File name of the sql file where db tables are defined

# --- Safety Check: Ensure sqlcmd is installed ---
if ! command -v sqlcmd &> /dev/null; then
    echo "Error: 'sqlcmd' command not found."
    echo "Please install sqlcmd."
    exit 1
fi

# --- Secure Password Prompt ---
if [ -z "$DB_PASSWORD" ]; then
    read -sp "Enter password for user '$DB_USER': " DB_PASSWORD
    echo ""
fi

# --- Table definition exec
if [ -f "$DB_TABLES_FILE" ]; then
    echo ">>> Processing Table Definitions from: $DB_TABLES_FILE"

    # -S: Server, -d: Database, -U: User, -P: Password, -i: Input File
    # -b: On error, batch abort, -I: Enable Quoted Identifiers
    sqlcmd -S "$DB_SERVER" -d "$DB_NAME" -U "$DB_USER" -P "$DB_PASSWORD" -I -b -i "$DB_TABLES_FILE"
else
    echo "Warning: table creation sql file does not exist, skipping"
fi

# --- Execution Order (Critical for SQL Dependencies) ---
FOLDERS=("functions" "views" "procedures" "triggers" "indexes")

echo "=========================================="
echo "Starting Database Rebuild: $DB_NAME"
echo "=========================================="

for folder in "${FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        echo ""
        echo ">>> Processing Folder: $folder"
        
        for file in "$folder"/*.sql; do

            [ -e "$file" ] || continue

            echo "    Executing: $(basename "$file")"
            
            # -S: Server, -d: Database, -U: User, -P: Password, -i: Input File
            # -b: On error, batch abort, -I: Enable Quoted Identifiers
            sqlcmd -S "$DB_SERVER" -d "$DB_NAME" -U "$DB_USER" -P "$DB_PASSWORD" -I -b -i "$file"
            
            if [ $? -ne 0 ]; then
                echo "!!!! ERROR executing $file. Skipping Build. !!!!"
                # exit 1 -- continue operation even on error. Uncomment to change
            fi
        done
    else
        echo "Warning: Folder '$folder' does not exist. Skipping."
    fi
done

echo ""
echo "=========================================="
echo "Build Complete Successfully."
echo "=========================================="

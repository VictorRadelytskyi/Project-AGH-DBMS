#!/usr/bin/env bash

# Rebuild SQL Server / Azure SQL database using FreeTDS utilities (bsqldb)
# - Fedora package: freetds
# - Executes .sql files in the same order as your original script
# - Normalizes batch separators: converts lines that are only "GO" into "go" (bsqldb expects "go")

set -u

# --- Configuration ---
DB_SERVER="janilowski.database.windows.net"   # can be hostname or a freetds.conf servername
DB_NAME="dev"
DB_USER="boss"

DB_TABLES_FILE="pbd_projekt.sql" # File name of the sql file where db tables are defined

# Optional: set TDS protocol version if you don't already have it configured.
# For SQL Server/Azure SQL, 7.4 is commonly used.
: "${TDSVER:=7.4}"
export TDSVER

# --- Safety Check: Ensure bsqldb is installed ---
if ! command -v bsqldb >/dev/null 2>&1; then
  echo "Error: 'bsqldb' command not found."
  echo "Install it with: sudo dnf install freetds"
  exit 1
fi

# --- Secure Password Prompt ---
if [ -z "${DB_PASSWORD:-}" ]; then
  read -rsp "Enter password for user '$DB_USER': " DB_PASSWORD
  echo ""
fi

# --- Helpers ---
normalize_go_to_tmp() {
  # Creates a temporary file with GO batch separators normalized to "go".
  # Only replaces lines that consist solely of GO (optionally surrounded by whitespace).
  local src="$1"
  local tmp
  tmp="$(mktemp)"

  # Replace: ^\s*GO\s*$  -> go
  sed -E 's/^[[:space:]]*[Gg][Oo][[:space:]]*$/go/' "$src" > "$tmp"
  printf '%s' "$tmp"
}

run_sql_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo "Warning: SQL file not found: $file"
    return 0
  fi

  local tmp
  tmp="$(normalize_go_to_tmp "$file")"

  # bsqldb exits >0 if the server cannot process the query (severity >10 often maps to exit code)
  bsqldb -S "$DB_SERVER" -D "$DB_NAME" -U "$DB_USER" -P "$DB_PASSWORD" -i "$tmp"
  local rc=$?

  rm -f "$tmp"
  return $rc
}

# --- Table definition exec ---
if [ -f "$DB_TABLES_FILE" ]; then
  echo ">>> Processing Table Definitions from: $DB_TABLES_FILE"
  run_sql_file "$DB_TABLES_FILE" || {
    echo "!!!! ERROR executing $DB_TABLES_FILE. Skipping Build. !!!!"
    # exit 1  # Uncomment to stop on first error
  }
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

    shopt -s nullglob
    for file in "$folder"/*.sql; do
      echo "    Executing: $(basename "$file")"

      run_sql_file "$file"
      rc=$?
      if [ $rc -ne 0 ]; then
        echo "!!!! ERROR executing $file (exit=$rc). !!!!"
        # exit 1  # Uncomment to stop on first error
      fi
    done
    shopt -u nullglob
  else
    echo "Warning: Folder '$folder' does not exist. Skipping."
  fi
done

echo ""
echo "=========================================="
echo "Build Complete."
echo "=========================================="

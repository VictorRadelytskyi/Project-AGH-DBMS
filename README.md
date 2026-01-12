# Projekt bazy danych firmy produkcyjnej. 

[Dokumentacja](https://victorradelytskyi.github.io/Project-AGH-DBMS/)

Autorzy poszczególnych zbiorów tabel:
- **Marcin Małek**:  Employees, EmployeePositions, Suppliers, Components
- **Victor Radelytskyi**: Products, Categories, Warehouse, ProductRecipes
- **Jan Iłowski**: Customers, CustomerDemographics, Orders, OrderDetails

---

## Instrukcja obsługi bazy danych

Poniższe instrukcje zakładają, że posiadasz dane dostępowe (login i hasło) do bazy danych MSSQL.

### 1. Czyszczenie bazy danych

Aby wykonać pełny reset bazy danych (usunięcie wszystkich tabel, procedur, widoków, funkcji i triggerów), użyj skryptu `00_db_cleanup.sql`.
⚠️ **Uwaga**:  Ten skrypt usuwa WSZYSTKIE dane z bazy.  Używaj ostrożnie! 

#### Za pomocą `sqlcmd`:
```bash
sqlcmd -S <SERWER> -d <BAZA_DANYCH> -U <UŻYTKOWNIK> -P <HASŁO> -I -b -i 00_db_cleanup. sql
```

#### Za pomocą FreeTDS (`bsqldb`):
```bash
bsqldb -S <SERWER> -D <BAZA_DANYCH> -U <UŻYTKOWNIK> -P <HASŁO> -i 00_db_cleanup.sql
```

---

### 2. Budowa bazy danych

Możesz odbudować bazę danych za pomocą jednego z dwóch skryptów. 

#### Opcja A: Skrypt z `sqlcmd` (Microsoft SQL Tools)

1. **Wymagania**:  Zainstalowane narzędzie `sqlcmd`
2. **Konfiguracja**:  Edytuj plik `scripts/rebuild_db.sh` i uzupełnij zmienne: 
   ```bash
   DB_SERVER="<adres_serwera>"
   DB_NAME="<nazwa_bazy>"
   DB_USER="<nazwa_użytkownika>"
   ```
3. **Uruchomienie**:
   ```bash
   cd <katalog_projektu>
   chmod +x scripts/rebuild_db.sh
   ./scripts/rebuild_db.sh
   ```
4. Skrypt poprosi o hasło, a następnie wykona: 
   - Utworzenie tabel z pliku `pbd_projekt.sql`
   - Załadowanie funkcji, widoków, procedur, triggerów i indeksów z odpowiednich folderów

#### Opcja B: Skrypt z FreeTDS (FOSS - dla systemów Linux/Fedora)

1. **Wymagania**: Zainstalowany pakiet `freetds` (np. `sudo dnf install freetds` na Fedorze)
2. **Konfiguracja**: Edytuj plik `scripts/rebuild_db_freetds.sh` i uzupełnij zmienne: 
   ```bash
   DB_SERVER="<adres_serwera>"
   DB_NAME="<nazwa_bazy>"
   DB_USER="<nazwa_użytkownika>"
   ```
3. **Uruchomienie**: 
   ```bash
   cd <katalog_projektu>
   chmod +x scripts/rebuild_db_freetds.sh
   ./scripts/rebuild_db_freetds.sh
   ```

---

## Generowanie dokumentacji SQL

Projekt zawiera skrypt Python do automatycznego generowania dokumentacji Markdown z plików SQL. 

#### Wymagania:
- Python 3.x
- MkDocs z motywem Material (do podglądu i hostingu)

#### Instalacja zależności:
```bash
pip install mkdocs mkdocs-material
```

#### Generowanie dokumentacji:
```bash
cd <katalog_projektu>
python3 scripts/gen_sql_docs.py
```

Opcjonalne flagi:
- `--root <ścieżka>` - katalog główny do skanowania (domyślnie: `.`)
- `--out <ścieżka>` - folder wyjściowy (domyślnie: `docs/sql`)
- `--title <tytuł>` - tytuł strony głównej dokumentacji
- `--check` - zakończ z błędem, jeśli jakikolwiek plik `.sql` nie ma nagłówka dokumentacji
- `--no-source` - nie dołączaj kodu źródłowego SQL do stron dokumentacji

---

### Uruchamianie dokumentacji lokalnie

Po wygenerowaniu dokumentacji możesz ją podglądać lokalnie za pomocą MkDocs:

```bash
cd <katalog_projektu>
mkdocs serve
```

Dokumentacja będzie dostępna pod adresem:  `http://127.0.0.1:8000`

#### Budowanie statycznej wersji:
```bash
mkdocs build
```

Statyczna wersja zostanie wygenerowana w folderze `site/`.

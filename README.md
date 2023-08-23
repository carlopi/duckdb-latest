# duckdb-latest

Stable deployment of duckdb nightly artifacts, to be reachable at a known location.

```bash
wget -q https://carlopi.github.io/duckdb-latest/duckdb_cli-osx-universal.zip
unzip duckdb_cli-osx-universal.zip
./duckdb -c "PRAGMA version;"
```

No interactions required with GitHub Web UI or figuring out gh CLI syntax, perfect for scripts.

## One liner install script
```
curl https://carlopi.github.io/duckdb-latest/install.sh | bash

## execute refresh script OR open a new tab

duckdb-latest -c "SELECT 'Quack!'"
```
`curl` and `unzip` are required to execute the script successfully.

Every script invocation will:
* trigger a download of the auto-detected package
* save it to  `~/.duckdb/latest/bin/duckdb-latest` (overriding what was there)
* execute a couple of SQL statement to verify installation
* add installation folder to the PATH (so it can then be executed)

Whenever you want to grab a newer version:
```
duckdb-update
```

##### Credits
Heavily inspired by installer available at https://bun.sh/

# duckdb-latest

Stable deployment of duckdb nightly artifacts, to be reachable at a known location.

```
wget -q https://carlopi.github.io/duckdb-latest/duckdb_cli-osx-universal.zip
unzip duckdb_cli-osx-universal.zip
./duckdb -c "PRAGMA version;"
```

No interactions required with GitHub Web UI or figuring out gh CLI syntax, perfect for scripts.

Fully customizable to your requirements.

### One line install.sh (Linux / OSX)
Using the stable deployment, install script for latest duckdb binaries:
```
curl https://carlopi.github.io/duckdb-latest/install.sh | bash
duckdb-latest -c "PRAGMA version;" 
```
`curl` and `unzip` are required to execute the script successfully.

Every script invocation will trigger a download of the auto-detected package, save it to  `~/.duckdb/bin/duckdb-latest` (potentially overriding what was there), and ensures duckdb-latest is in the path so it can be then executed.

Heavily inspired by installer available at https://bun.sh/



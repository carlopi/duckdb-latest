mkdir -p filter
curl https://carlopi.github.io/duckdb-latest/duckdb_cli-windows-amd64.zip -o filter/duckdb_cli-windows-amd64.zip
curl https://carlopi.github.io/duckdb-latest/duckdb_cli-osx-universal.zip -o filter/duckdb_cli-osx-universal.zip
curl https://carlopi.github.io/duckdb-latest/duckdb_cli-linux-amd64.zip -o filter/duckdb_cli-linux-amd64.zip
curl https://carlopi.github.io/duckdb-latest/libduckdb-windows-amd64.zip -o filter/libduckdb-windows-amd64.zip
curl https://carlopi.github.io/duckdb-latest/libduckdb-osx-universal.zip -o filter/libduckdb-osx-universal.zip
curl https://carlopi.github.io/duckdb-latest/libduckdb-linux-amd64.zip -o filter/libduckdb-linux-amd64.zip
cp collect/duckdb-binaries-windows/duckdb_cli-windows-amd64.zip filter/.
cp collect/duckdb-binaries-osx/duckdb_cli-osx-universal.zip filter/.
cp collect/duckdb-binaries-linux/duckdb_cli-linux-amd64.zip filter/.
cp collect/duckdb-binaries-windows/libduckdb-windows-amd64.zip filter/.
cp collect/duckdb-binaries-osx/libduckdb-osx-universal.zip filter/.
cp collect/duckdb-binaries-linux/libduckdb-linux-amd64.zip filter/.

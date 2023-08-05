gh run download $(gh run list -L 3 -R duckdb/duckdb -e repository_dispatch -w Windows --json databaseId | jq "[.[]][1].databaseId") -R duckdb/duckdb --dir collect
gh run download $(gh run list -L 3 -R duckdb/duckdb -e repository_dispatch -w OSX --json databaseId | jq "[.[]][1].databaseId") -R duckdb/duckdb --dir collect
gh run download $(gh run list -L 3 -R duckdb/duckdb -e repository_dispatch -w LinuxRelease --json databaseId | jq "[.[]][1].databaseId") -R duckdb/duckdb --dir collect

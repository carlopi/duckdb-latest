gh run download $(gh run list -L 7 -R duckdb/duckdb -e repository_dispatch -w Windows --json databaseId | jq "[.[]][$DAYS].databaseId") -R duckdb/duckdb --dir collect
gh run download $(gh run list -L 7 -R duckdb/duckdb -e repository_dispatch -w OSX --json databaseId | jq "[.[]][$DAYS].databaseId") -R duckdb/duckdb --dir collect
gh run download $(gh run list -L 7 -R duckdb/duckdb -e repository_dispatch -w LinuxRelease --json databaseId | jq "[.[]][$DAYS].databaseId") -R duckdb/duckdb --dir collect

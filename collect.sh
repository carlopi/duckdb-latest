gh run download $(gh run list -L 20 -R duckdb/duckdb -e repository_dispatch -w Windows --json databaseId | jq "[.[]][$DAYS].databaseId") -R duckdb/duckdb --dir collect
gh run download $(gh run list -L 20 -R duckdb/duckdb -e repository_dispatch -w OSX --json databaseId | jq "[.[]][$DAYS].databaseId") -R duckdb/duckdb --dir collect
gh run download $(gh run list -L 20 -R duckdb/duckdb -e repository_dispatch -w LinuxRelease --json databaseId | jq "[.[]][$DAYS].databaseId") -R duckdb/duckdb --dir collect
gh run list -L 7 -R duckdb/duckdb -e repository_dispatch -w LinuxRelease --json headSha | jq "[.[]][0].headSha" > hash
HASHED_VALUE=$(cat hash | head -c 9 | tail -c 8)
echo "HASH=$HASHED_VALUE" >> $GITHUB_ENV

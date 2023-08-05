#!/usr/bin/env bash
set -euo pipefail

if [[ ${OS:-} = Windows_NT ]]; then
    echo 'error: Please install DuckDB using Windows Subsystem for Linux'
    exit 1
fi

# Reset
Color_Off=''

# Regular Colors
Red=''
Green=''
Dim='' # White

# Bold
Bold_White=''
Bold_Green=''

if [[ -t 1 ]]; then
    # Reset
    Color_Off='\033[0m' # Text Reset

    # Regular Colors
    Red='\033[0;31m'   # Red
    Green='\033[0;32m' # Green
    Dim='\033[0;2m'    # White

    # Bold
    Bold_Green='\033[1;32m' # Bold Green
    Bold_White='\033[1m'    # Bold White
fi

error() {
    echo -e "${Red}error${Color_Off}:" "$@" >&2
    exit 1
}

info() {
    echo -e "${Dim}$@ ${Color_Off}"
}

info_bold() {
    echo -e "${Bold_White}$@ ${Color_Off}"
}

success() {
    echo -e "${Green}$@ ${Color_Off}"
}

command -v unzip >/dev/null ||
    error 'unzip is required to install duckdb'

case $(uname -ms) in
'Darwin x86_64')
    target=duckdb_cli-osx-universal
    ;;
'Darwin arm64')
    target=duckdb_cli-osx-universal
    ;;
'Linux aarch64' | 'Linux arm64')
    echo 'error: Missing installer, please report this error'
    exit 1
    ;;
'Linux x86_64' | *)
    target=duckdb_cli-linux-amd64
    ;;
esac

if [[ $target = darwin-x64 ]]; then
    # Is this process running in Rosetta?
    # redirect stderr to devnull to avoid error message when not running in Rosetta
    if [[ $(sysctl -n sysctl.proc_translated 2>/dev/null) = 1 ]]; then
        target=duckdb_cli-osx-universal.zip
        info "Your shell is running in Rosetta 2. Downloading duckdb for $target instead"
    fi
fi

GITHUB=${GITHUB-"https://carlopi.github.io"}

github_repo="$GITHUB/duckdb-latest"

exe_name=duckdb

duckdb_uri=$github_repo/$target.zip

install_env=DUCKDB_INSTALL
bin_env=\$$install_env/bin

install_dir=${!install_env:-$HOME/.duckdb}
bin_dir=$install_dir/bin
exe=$bin_dir/duckdb-latest

if [[ ! -d $bin_dir ]]; then
    mkdir -p "$bin_dir" ||
        error "Failed to create install directory \"$bin_dir\""
fi

curl --fail --location --progress-bar --output "$exe.zip" "$duckdb_uri" ||
    error "Failed to download duckdb from \"$duckdb_uri\""

unzip -oqd "$bin_dir" "$exe.zip" ||
    error 'Failed to extract duckdb'

mv "$bin_dir/$exe_name" "$exe" ||
    error 'Failed to move extracted duckdb to destination'

chmod +x "$exe" ||
    error 'Failed to set permissions on duckdb executable'

rm "$exe.zip"

tildify() {
    if [[ $1 = $HOME/* ]]; then
        local replacement=\~/

        echo "${1/$HOME\//$replacement}"
    else
        echo "$1"
    fi
}

success "duckdb was installed successfully to $Bold_Green$(tildify "$exe")"

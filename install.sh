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

echo "$@"

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
        info "Your shell is running in Rosetta 2. Downloading duckdb-latest for $target instead"
    fi
fi

GITHUB=${GITHUB-"https://carlopi.github.io"}

github_repo="$GITHUB/duckdb-latest"

exe_name=duckdb

duckdb_uri=$github_repo/$target.zip

install_env=DUCKDB_INSTALL
bin_env=\$$install_env/latest/bin

install_dir=${!install_env:-$HOME/.duckdb}
bin_dir=$install_dir/latest/bin
exe=$bin_dir/duckdb-latest
updater=$bin_dir/duckdb-update

if [[ ! -d $bin_dir ]]; then
    mkdir -p "$bin_dir" ||
        error "Failed to create install directory \"$bin_dir\""
fi

cmp --silent "$0" "$updater" || ( cp "$0" "$updater" && chmod +x "$updater" )

curl --fail --location --progress-bar --output "$exe.zip" "$duckdb_uri" ||
    error "Failed to download duckdb-latest from \"$duckdb_uri\""

unzip -oqd "$bin_dir" "$exe.zip" ||
    error 'Failed to extract duckdb'

mv "$bin_dir/$exe_name" "$exe" ||
    error 'Failed to move extracted duckdb-latest to destination'

chmod +x "$exe" ||
    error 'Failed to set permissions on duckdb-latest executable'

rm "$exe.zip"
  
tildify() {
    if [[ $1 = $HOME/* ]]; then
        local replacement=\~/

        echo "${1/$HOME\//$replacement}"
    else
        echo "$1"
    fi
}

success "duckdb-latest was installed successfully to $Bold_Green$(tildify "$exe")"

refresh_command=''

tilde_bin_dir=$(tildify "$bin_dir")
quoted_install_dir=\"${install_dir//\"/\\\"}\"

if [[ $quoted_install_dir = \"$HOME/* ]]; then
    quoted_install_dir=${quoted_install_dir/$HOME\//\$HOME/}
fi

echo

case $(basename "$SHELL") in
fish)
    commands=(
        "set --export $install_env $quoted_install_dir"
        "set --export PATH $bin_env \$PATH"
    )

    fish_config=$HOME/.config/fish/config.fish
    tilde_fish_config=$(tildify "$fish_config")

    if [[ -w $fish_config ]]; then
        {
            echo -e '\n# duckdb-latest'

            for command in "${commands[@]}"; do
                echo "$command"
            done
        } >>"$fish_config"

        info "Added \"$tilde_bin_dir\" to \$PATH in \"$tilde_fish_config\""

        refresh_command="source $tilde_fish_config"
    else
        echo "Manually add the directory to $tilde_fish_config (or similar):"

        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;
zsh)
    commands=(
        "export $install_env=$quoted_install_dir"
        "export PATH=\"$bin_env:\$PATH\""
    )

    zsh_config=$HOME/.zshrc
    tilde_zsh_config=$(tildify "$zsh_config")

    if [[ -w $zsh_config ]]; then
        {
            echo -e '\n# duckdb-latest'

            for command in "${commands[@]}"; do
                echo "$command"
            done
        } >>"$zsh_config"

        info "Added \"$tilde_bin_dir\" to \$PATH in \"$tilde_zsh_config\""

        refresh_command="exec $SHELL"
    else
        echo "Manually add the directory to $tilde_zsh_config (or similar):"

        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;
bash)
    commands=(
        "export $install_env=$quoted_install_dir"
        "export PATH=$bin_env:\$PATH"
    )

    bash_configs=(
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
    )

    if [[ ${XDG_CONFIG_HOME:-} ]]; then
        bash_configs+=(
            "$XDG_CONFIG_HOME/.bash_profile"
            "$XDG_CONFIG_HOME/.bashrc"
            "$XDG_CONFIG_HOME/bash_profile"
            "$XDG_CONFIG_HOME/bashrc"
        )
    fi

    set_manually=true
    for bash_config in "${bash_configs[@]}"; do
        tilde_bash_config=$(tildify "$bash_config")

        if [[ -w $bash_config ]]; then
            {
                echo -e '\n# duckdb-latest'

                for command in "${commands[@]}"; do
                    echo "$command"
                done
            } >>"$bash_config"

            info "Added \"$tilde_bin_dir\" to \$PATH in \"$tilde_bash_config\""

            refresh_command="source $bash_config"
            set_manually=false
            break
        fi
    done

    if [[ $set_manually = true ]]; then
        echo "Manually add the directory to $tilde_bash_config (or similar):"

        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;
*)
    echo 'Manually add the directory to ~/.bashrc (or similar):'
    info_bold "  export $install_env=$quoted_install_dir"
    info_bold "  export PATH=\"$bin_env:\$PATH\""
    ;;
esac
echo
info "Running demo:"
"$exe" --echo -c "SELECT 'Quack from DuckDB!' AS welcome;"
"$exe" --echo -c "PRAGMA version;"
echo
echo
info "~ To get started, run:"
if [[ $refresh_command ]]; then
    info_bold " $refresh_command"
fi

info_bold " duckdb-latest --help"
echo
info "~ Or explicitly:"
info_bold " $exe --help"

echo
info "~ To then download the lastest duckdb-latest:"
info_bold " duckdb-update"


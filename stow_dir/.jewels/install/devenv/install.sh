#!/usr/bin/env bash

OS_=$(uname | tr '[:upper:]' '[:lower:]')

function Execute() {
    # Execute scripts from params
    # Params:
    #   1 - path to darwin script or empty
    #   2 - path to linux script or empty

    darwin_script=$1
    linux_script=$2

    if [[ -n "$darwin_script" &&  "$OS_" == "darwin" ]]; then
        bash "$darwin_script"
    fi
    if [[ -n "$linux_script" && "$OS_" == "linux" ]]; then
        bash "$linux_script"
    fi
}

if [[ "$OS_" == "linux" ]]; then
    echo "=== Update system packages ..."
    bash './linux/update_packages.sh'
    echo "=== Done."
fi

echo "=== Install homebrew ..."
Execute '' './linux/install_homebrew.sh'
echo "=== Done."

echo "=== Install base packages ..."
Execute './darwin/install_base.sh' './linux/install_base.sh'
echo "=== Done."

echo "=== Install devtools via homebrew ..."
bash "./universal/install_devtools_homebrew.sh"
Execute './darwin/install_devtools_homebrew.sh' './linux/install_devtools_homebrew.sh'
echo "=== Done."

echo "=== Install fonts ..."
Execute '' './linux/install_fonts.sh'
echo "=== Done."

echo "=== Install tmux ..."
bash "./universal/install_tmux.sh"
echo "=== Done."

echo "=== Install pipx ..."
bash "./universal/install_pipx.sh"
echo "=== Done."

echo "=== Install pyenv ..."
bash "./universal/install_pyenv.sh"
echo "=== Done."

echo "=== Install node.js ..."
bash "./universal/install_nodejs.sh"
echo "=== Done."

echo "=== Install deno ..."
bash "./universal/install_deno.sh"
echo "=== Done."

echo "=== Install postgresql client ..."
bash "./universal/install_postgresql_client.sh"
echo "=== Done."

if [[ "$OS_" == "linux" ]]; then
    echo "=== Install midnight commander ..."
    bash "./linux/install_mc.sh"
    echo "=== Done."
fi

echo "=== Install vim ..."
bash "./universal/install_vim.sh"
echo "=== Done."

echo "=== Install zsh + oh my zsh ..."
Execute './darwin/install_zsh.sh' './linux/install_zsh.sh'
bash "./universal/install_zsh.sh"
echo "=== Done."

echo "=== Install golang ..."
bash "./universal/install_golang.sh"
echo "=== Done."

echo "=== Install rust ..."
bash "./universal/install_rust.sh"
echo "=== Done."

echo "=== Create directories ..."
bash "./universal/create_directories.sh"
echo "=== Done."

echo "=== Apply configs ..."
# add configs
echo "=== Done."

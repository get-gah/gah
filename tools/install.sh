#!/usr/bin/env bash

# gah! installer
#
# @author Marek `marverix` Sierociński
# @license GNU GPLv3

# Pipeline mode
set -e

# Configuration
if [[ -z "$GAH_INSTALL_DIR" ]]; then
	if [[ $EUID -ne 0 ]]; then
		GAH_INSTALL_DIR="$HOME/.local/bin"
	else
		GAH_INSTALL_DIR="/usr/local/bin"
	fi
fi

#--------------------------------------------------
#region Utils
function print_blue() {
	echo -e "\033[0;34m$1\033[0m"
}

function print_green() {
	echo -e "\033[0;32m$1\033[0m"
}

function print_yellow() {
	echo -e "\033[0;33m$1\033[0m"
}

function throw_error() {
	echo -e "\033[0;31mError: $2\033[0m" >&2
	exit $1
}

function require_command() {
	print_blue "Checking if $1 is installed..."
	if ! command -v $1 2>&1 >/dev/null; then
		throw_error 2 "$1 is not installed"
	fi
	print_green "OK"
}

#endregion
#--------------------------------------------------

# Require that bash is at least 4.0
print_blue "Checking if Bash 4.0 or higher is installed..."
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
	throw_error 1 "Bash 4.0 or higher is required"
fi
print_green "OK"

# Check if required commands are installed
require_command tar
require_command unzip
require_command curl
require_command jq

# Ensure ~/.local/bin exists
print_blue "Ensuring $GAH_INSTALL_DIR exists..."
mkdir -p "$GAH_INSTALL_DIR"
print_green "OK"

# Check if ~/.local/bin is in PATH
print_blue "Checking if $GAH_INSTALL_DIR is in PATH..."
if [[ ":$PATH:" != *":$GAH_INSTALL_DIR:"* ]]; then
	print_yellow "WARNING: $GAH_INSTALL_DIR is not in PATH. gah will not work if $GAH_INSTALL_DIR is not in PATH."
else
	print_green "OK, looks good!"
fi

# Check gah latest tag
print_blue "Checking latest gah release..."
tag=$(curl -s https://api.github.com/repos/marverix/gah/releases/latest | jq -r '.tag_name')
print_green "OK, latest tag is $tag"

# Download gah! script
print_blue "Downloading gah $tag script..."
curl -sL https://raw.githubusercontent.com/marverix/gah/refs/tags/$tag/gah -o "$GAH_INSTALL_DIR/gah"
chmod +x "$GAH_INSTALL_DIR/gah"
print_green "OK"

print_green "Done!"

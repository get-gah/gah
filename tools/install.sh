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
require_command curl || require_command wget
require_command jq
require_command openssl

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

if [[ -n "${GITHUB_PAT:-}" ]]; then
	GITHUB_AUTH_ARGS=(--header "Authorization: token ${GITHUB_PAT}")
	print_green "Using GitHub Personal Access Token for API requests"
else
	GITHUB_AUTH_ARGS=()
	print_yellow "No GITHUB_PAT found - using unauthenticated GitHub API (rate limited to 60 requests/hour)"
fi

# Check gah latest tag
print_blue "Checking latest gah release..."
if command -v curl >/dev/null 2>&1; then
	tag=$(curl -s "${GITHUB_AUTH_ARGS[@]}" https://api.github.com/repos/get-gah/gah/releases/latest | jq -r '.tag_name')
else
	tag=$(wget -q "${GITHUB_AUTH_ARGS[@]}" -O- https://api.github.com/repos/get-gah/gah/releases/latest | jq -r '.tag_name')
fi
print_green "OK, latest tag is $tag"

# Download gah! script
print_blue "Downloading gah $tag script..."
if command -v curl >/dev/null 2>&1; then
	curl -sL https://raw.githubusercontent.com/get-gah/gah/refs/tags/$tag/gah -o "$GAH_INSTALL_DIR/gah"
else
	wget -q https://raw.githubusercontent.com/get-gah/gah/refs/tags/$tag/gah -O "$GAH_INSTALL_DIR/gah"
fi
chmod +x "$GAH_INSTALL_DIR/gah"
print_green "OK"

print_green "Done!"

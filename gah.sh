#!/usr/bin/env bash

# gah! Get App Homie!
#
# @author Marek `marverix` Sierociński
# @license GNU GPLv3

# Pipeline mode
set -e

#--------------------------------------------------
#region Constants

VERSION="0.1.0"
HELP_STRING="Type 'gah help' to show help."

#endregion
#--------------------------------------------------
#region Variables

tmp_dir=""

#endregion
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
	echo -e "\033[0;31m$1\033[0m"
	exit 1
}

function print_debug() {
	if [[ "$DEBUG" == "true" ]]; then
		echo -e "[DEBUG] $1"
	fi
}

function cleanup() {
	if [[ -n "$tmp_dir" && -d "$tmp_dir" ]]; then
		rm -fr "$tmp_dir"
	fi
}

function fetch_release_info() {
	local suffix="latest"
	if [[ "$2" != "latest" ]]; then
		suffix="tags/$2"
	fi

	local url="https://api.github.com/repos/$1/releases/$suffix"
	curl -s "$url" > release.json

	local err_status=$(jq -r '.status' release.json)
	if [[ "$err_status" != "null" ]]; then
		throw_error "Error: Couldn't fetch release information.\nResponse from GitHub API: [$err_status] $(jq -r '.message' release.json)"
	fi
}

function find_download_url() {
	release_json="$1"
	# Iterate over assets and find the one
}

#endregion
#--------------------------------------------------
#region Known aliases

declare -A aliases
aliases[gh]="cli/cli"
aliases[helm]="helm/helm"
aliases[k9s]="derailed/k9s"
aliases[kops]="kubernetes/kops"
aliases[argocd]="argoproj/argo-cd"
aliases[goss]="goss-org/goss"

#endregion
#--------------------------------------------------
#region Command functions

function command_help() {
	echo "gah"
	echo "  install <owner/repo_name | known_alias> [<VERSION>]"
	echo "  show <aliases>"
	echo "  help"
	echo "  VERSION"
	exit 0
}

function command_version() {
	echo $VERSION
	exit 0
}

function command_install() {
	# Create temporary directory
	tmp_dir=$(mktemp -d)
	echo "Temporary directory: $tmp_dir"

	# Change to temporary directory
	cd $tmp_dir

	# Fetch the release information
	fetch_release_info "$1" "$2"

	# Find the download URL
	find_download_url "$tmp_dir/release.json"
}

function command_show_aliases() {
	echo "Known aliases:"
	for alias in "${!aliases[@]}"; do
		echo "  $alias -> ${aliases[$alias]}"
	done
}

#endregion
#--------------------------------------------------

# Main handler
trap cleanup EXIT ERR SIGINT SIGTERM

if [[ -z "$1" || "$1" == "help" ]]; then
	command_help

elif [[ "$1" == "VERSION" ]]; then
	command_version

elif [[ "$1" == "install" ]]; then
	if [[ -z "$2" ]]; then
		throw_error "Please provide either repo in format 'owner/repo_name' or known alias.\n$HELP_STRING"
	
	elif [[ "$2" == *"/"* ]]; then
		if [[ "$2" =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+$ ]]; then
			repo="$2"
		else
			throw_error "Given string '$2' is not in format 'owner/repo_name'.\n$HELP_STRING"
		fi

	elif [[ -n "${aliases[$2]}" ]]; then
		repo="${aliases[$2]}"

	else
		throw_error "Given string '$2' is not a known alias.\nTo see known aliases type 'gah show aliases'."
	fi

	tag="$3"
	if [[ -z "$3" ]]; then
		tag=latest
	fi

	command_install "$repo" "$tag"

elif [[ "$1" == "show" ]]; then
	if [[ "$2" == "aliases" ]]; then
		command_show_aliases

	else
		throw_error "Unknown subcommand.\n$HELP_STRING"
	fi

else
	throw_error "Unknown command '$command'.\n$HELP_STRING"
fi

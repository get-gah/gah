#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source "$SCRIPT_DIR/../../../gah"

while IFS= read -r -d '' directory; do
	dir_name=$(basename "$directory")
	echo "Processing $dir_name"

	if [[ "$dir_name" == _* ]]; then
		continue
	fi

	cd "$directory"
	if [[ -f "release.json" ]]; then
		echo "release.json already exists in $directory - skipping"
		continue
	fi
	
	repo=$(get_known_alias "$dir_name")
	echo "Fetching release info for $repo"
	fetch_release_info "$repo"

done < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"
load "test_helper/common"
load "$DIR/gah"

setup() {
	common_setup
	DEBUG=""

	# Isolate config and cache from the real ones
	GAH_CONFIG_DIR="$BATS_TEST_TMPDIR/config"
	GAH_LOCAL_ALIASES_FILE="$GAH_CONFIG_DIR/local_aliases.json"
	GAH_CACHED_ALIASES_FILE="$BATS_TEST_TMPDIR/aliases.json"
	echo '{"aliases":{"db-tool":"db-owner/db-repo","shared":"db-owner/shared"}}' > "$GAH_CACHED_ALIASES_FILE"
}

teardown() {
	common_teardown
}

@test "command_local_aliases_show should print empty object when file does not exist" {
	run command_local_aliases_show

	assert_success
	assert_line --index 0 "Local aliases:"
	assert_line --index 1 "{}"
}

@test "command_local_aliases_add should create file and add alias" {
	run command_local_aliases_add "foo" "owner/repo"

	assert_success
	assert [ -f "$GAH_LOCAL_ALIASES_FILE" ]
	run jq -r '.aliases.foo' "$GAH_LOCAL_ALIASES_FILE"
	assert_output "owner/repo"
}

@test "command_local_aliases_add should overwrite existing alias and keep others" {
	command_local_aliases_add "foo" "owner/repo"
	command_local_aliases_add "bar" "owner/other"
	command_local_aliases_add "foo" "owner/new"

	run jq -r '.aliases.foo, .aliases.bar' "$GAH_LOCAL_ALIASES_FILE"
	assert_line --index 0 "owner/new"
	assert_line --index 1 "owner/other"
}

@test "command_local_aliases_add should fail without arguments" {
	run command_local_aliases_add

	assert_failure 6
	assert_output --partial "Please provide alias name and repo"
}

@test "command_local_aliases_add should fail without repo" {
	run command_local_aliases_add "foo"

	assert_failure 6
}

@test "command_local_aliases_add should fail for invalid repo format" {
	run command_local_aliases_add "foo" "not-a-repo"

	assert_failure 2
	assert_output --partial "is not in format 'owner/repo_name'"
	assert [ ! -f "$GAH_LOCAL_ALIASES_FILE" ]
}

@test "command_local_aliases_show should print added aliases" {
	command_local_aliases_add "foo" "owner/repo"

	run command_local_aliases_show

	assert_success
	assert_output --partial '"foo": "owner/repo"'
}

@test "command_local_aliases_remove should remove alias and keep others" {
	command_local_aliases_add "foo" "owner/repo"
	command_local_aliases_add "bar" "owner/other"

	run command_local_aliases_remove "foo"

	assert_success
	run jq -r '.aliases | keys[]' "$GAH_LOCAL_ALIASES_FILE"
	assert_output "bar"
}

@test "command_local_aliases_remove should fail without argument" {
	run command_local_aliases_remove

	assert_failure 6
	assert_output --partial "Please provide alias name"
}

@test "command_local_aliases_remove should fail for unknown alias" {
	command_local_aliases_add "foo" "owner/repo"

	run command_local_aliases_remove "nope"

	assert_failure 7
	assert_output --partial "is not a local alias"
}

@test "command_local_aliases_remove should fail when file does not exist" {
	run command_local_aliases_remove "foo"

	assert_failure 7
}

@test "get_local_alias should print null when file does not exist" {
	run get_local_alias "foo"

	assert_success
	assert_output "null"
}

@test "get_local_alias should print repo for existing alias" {
	command_local_aliases_add "foo" "owner/repo"

	run get_local_alias "foo"

	assert_output "owner/repo"
}

@test "get_known_alias should fall back to DB when no local alias" {
	run get_known_alias "db-tool"

	assert_output "db-owner/db-repo"
}

@test "get_known_alias should prefer local alias over DB" {
	command_local_aliases_add "shared" "me/mine"

	run get_known_alias "shared"

	assert_output "me/mine"
}

@test "get_known_alias should print null for unknown alias" {
	run get_known_alias "nope"

	assert_output "null"
}

@test "command_help should list local-aliases" {
	run command_help

	assert_success
	assert_output --partial "local-aliases <show | add"
}

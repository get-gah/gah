load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"
load "test_helper/bats-mock/stub"
load "test_helper/common"
load "$DIR/gah"

setup() {
	common_setup
}

teardown() {
	common_teardown

	if [[ -n "$TEST_TEMP_DIR" && -d "$TEST_TEMP_DIR" ]]; then
		rm -rf "$TEST_TEMP_DIR"
		TEST_TEMP_DIR=""
	fi
	
	unstub uname || true
	unstub curl || true
}

@test "fetch_release_info should print an error message if the release info cannot be fetched" {
	stub curl "-s * : cat '$DIR/test/fixtures/releases/_error/release.json'"

	TEST_TEMP_DIR=$(mktemp -d)
	cd "$TEST_TEMP_DIR"

	run fetch_release_info

	assert_failure 13
	assert_output --partial "Error: Couldn't fetch release information."
	assert_output --partial "Response from GitHub API: [419] I'm a teapot"
}

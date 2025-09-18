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

@test "get_fetch_release_info_url should print the correct URL if no version is provided" {
	run get_fetch_release_info_url "abc/def" ""

	assert_success
	assert_output "https://api.github.com/repos/abc/def/releases/latest"
}

@test "get_fetch_release_info_url should print the correct URL if a version is latest" {
	run get_fetch_release_info_url "abc/def" "latest"

	assert_success
	assert_output "https://api.github.com/repos/abc/def/releases/latest"
}

@test "get_fetch_release_info_url should print the correct URL if a version is provided" {
	run get_fetch_release_info_url "abc/def" "v1.2.3"

	assert_success
	assert_output "https://api.github.com/repos/abc/def/releases/tags/v1.2.3"
}

@test "fetch_release_info should save the release info to a file" {
	stub curl "-s * : cat '$DIR/test/fixtures/releases/argocd/release.json'"

	TEST_TEMP_DIR=$(mktemp -d)
	cd "$TEST_TEMP_DIR"

	run fetch_release_info

	assert_success
	assert [ -f "release.json" ]
}

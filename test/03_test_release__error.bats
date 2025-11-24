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
	unstub wget || true
}

@test "fetch_release_info should print an network error message if the release info cannot be fetched" {
	stub curl "-s * : touch release.json"
	stub wget "-q * : touch release.json"

	TEST_TEMP_DIR=$(mktemp -d)
	cd "$TEST_TEMP_DIR"
	
	run fetch_release_info

	assert_failure 19
	assert_output --partial "Failed to fetch release information from GitHub API."
	assert_output --partial "No response received. Check your network connection."
}

@test "fetch_release_info should print an json error message if the release info is not valid json" {
	stub curl "-s * : echo 'not a json'"
	stub wget "-q * : echo 'not a json'"

	TEST_TEMP_DIR=$(mktemp -d)
	cd "$TEST_TEMP_DIR"
	
	run fetch_release_info

	assert_failure 20
	assert_output --partial "Failed to parse GitHub API response."
	assert_output --partial "Received invalid JSON. The API might be unavailable."
}

@test "fetch_release_info should print an rate limit error message if the response indicates rate limiting" {
	stub curl "-s * : cat '$DIR/test/fixtures/releases/_error/rate_limit_release.json'"
	stub wget "-q * : cat '$DIR/test/fixtures/releases/_error/rate_limit_release.json'"

	TEST_TEMP_DIR=$(mktemp -d)
	cd "$TEST_TEMP_DIR"
	
	run fetch_release_info

	assert_failure 21
	assert_output --partial "GitHub API rate limit exceeded."
	assert_output --partial "Unauthenticated requests are limited to 60 per hour."
	assert_output --partial "Authenticated requests get 5,000 per hour."
	assert_output --partial "To authenticate, set the GITHUB_PAT environment variable:"
	assert_output --partial "export GITHUB_PAT=\"your_token_here\""
	assert_output --partial "Create a token at: https://github.com/settings/tokens"
}

@test "fetch_release_info should print an error message if the release info contains some other error" {
	stub curl "-s * : cat '$DIR/test/fixtures/releases/_error/teapot_release.json'"
	stub wget "-q * : cat '$DIR/test/fixtures/releases/_error/teapot_release.json'"

	TEST_TEMP_DIR=$(mktemp -d)
	cd "$TEST_TEMP_DIR"

	run fetch_release_info

	assert_failure 13
	assert_output --partial "Error: Couldn't fetch release information."
	assert_output --partial "Response from GitHub API [419]: I'm a teapot"
}

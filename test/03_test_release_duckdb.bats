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

@test "find_download_url should print match for the correct asset [linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/duckdb/release.json"

	assert_success
	assert_output "https://github.com/duckdb/duckdb/releases/download/v1.4.0/duckdb_cli-linux-amd64.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/libduckdb-linux-amd64.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/static-libs-linux-amd64.zip"
}

@test "find_download_url should print match for the correct asset [linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/duckdb/release.json"

	assert_success
	assert_output "https://github.com/duckdb/duckdb/releases/download/v1.4.0/duckdb_cli-linux-arm64.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/libduckdb-linux-arm64.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/static-libs-linux-arm64.zip"
}

@test "find_download_url should print match for the correct asset [macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/duckdb/release.json"

	assert_success
	assert_output "https://github.com/duckdb/duckdb/releases/download/v1.4.0/duckdb_cli-osx-universal.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/libduckdb-osx-universal.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/static-libs-osx-amd64.zip"
}

@test "find_download_url should print match for the correct asset [macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/duckdb/release.json"

	assert_success
	assert_output "https://github.com/duckdb/duckdb/releases/download/v1.4.0/duckdb_cli-osx-universal.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/libduckdb-osx-universal.zip
https://github.com/duckdb/duckdb/releases/download/v1.4.0/static-libs-osx-arm64.zip"
}

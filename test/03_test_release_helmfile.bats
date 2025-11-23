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
	run find_download_url "$DIR/test/fixtures/releases/helmfile/release.json"

	assert_success
	assert_output "https://github.com/helmfile/helmfile/releases/download/v1.1.7/helmfile_1.1.7_linux_amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/helmfile/release.json"

	assert_success
	assert_output "https://github.com/helmfile/helmfile/releases/download/v1.1.7/helmfile_1.1.7_linux_arm64.tar.gz"
}

@test "find_download_url should print match for the correct asset [macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/helmfile/release.json"

	assert_success
	assert_output "https://github.com/helmfile/helmfile/releases/download/v1.1.7/helmfile_1.1.7_darwin_amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/helmfile/release.json"

	assert_success
	assert_output "https://github.com/helmfile/helmfile/releases/download/v1.1.7/helmfile_1.1.7_darwin_arm64.tar.gz"
}

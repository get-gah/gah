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

@test "find_download_url should print match for the correct asset [linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'" \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/helm/release.json"

	assert_success
	assert_output "https://get.helm.sh/helm-v3.16.3-linux-amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'" \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/helm/release.json"

	assert_success
	assert_output "https://get.helm.sh/helm-v3.16.3-linux-arm64.tar.gz"
}

@test "find_download_url should print match for the correct asset [macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'" \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/helm/release.json"

	assert_success
	assert_output "https://get.helm.sh/helm-v3.16.3-darwin-amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'" \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/helm/release.json"

	assert_success
	assert_output "https://get.helm.sh/helm-v3.16.3-darwin-arm64.tar.gz"
}

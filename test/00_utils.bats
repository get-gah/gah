load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"
load "test_helper/bats-mock/stub"
load "test_helper/common"
load "$DIR/gah"

setup() {
	common_setup
	DEBUG=""
}

teardown() {
	common_teardown
}

@test "get_os should print the OS" {
	run get_os

	assert_output "linux"
}

@test "get_arch should print the architecture" {
	run get_arch

	assert_output "amd64"
}

@test "supports_bash_regex should return true for Bash 4+" {
	# This test will pass/fail based on actual Bash version
	# If running Bash 4+, it should succeed
	if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
		run supports_bash_regex
		assert_success
	else
		run supports_bash_regex
		assert_failure
	fi
}

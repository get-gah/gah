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

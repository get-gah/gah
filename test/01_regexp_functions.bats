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
	
	unstub uname || true
}

@test "get_os should support Linux" {
	stub uname "-s : echo 'Linux'"
	run get_os

	assert_success
	assert_output "linux"
}

@test "get_os should support Linux-any-other" {
	stub uname "-s : echo 'Linux-any-other'"
	run get_os

	assert_success
	assert_output "linux"
}

@test "get_os should support Darwin" {
	stub uname "-s : echo 'Darwin 19.6.0'"
	run get_os

	assert_success
	assert_output "macos"
}

@test "get_os should support Darwin X.Y.Z" {
	stub uname "-s : echo 'Darwin X.Y.Z'"
	run get_os

	assert_success
	assert_output "macos"
}

@test "get_os should not support any other OS type" {
	stub uname "-s : echo 'FreeBSD'"
	run get_os

	assert_output "NOT_SUPPORTED"
}

@test "get_os_regexp_part should return proper string for linux" {
	stub uname "-s : echo 'Linux-gnu'"
	run get_os_regexp_part

	assert_success
	assert_output '[._-](unknown[._-])?(linux|linux-gnu|linux-musl)'
}

@test "get_os_regexp_part should return proper string for macos" {
	stub uname "-s : echo 'Darwin 19.6.0'"
	run get_os_regexp_part

	assert_success
	assert_output '[._-](apple[._-])?(darwin|macos|osx)'
}

@test "get_os_regexp_part should exit with error code" {
	stub uname "-s : echo 'FreeBSD'"
	run get_os_regexp_part

	assert_failure 10
	assert_output --partial 'Error: Your OS type is not supported'
}

@test "get_arch should support x86_64" {
	stub uname "-m : echo 'x86_64'"
	run get_arch

	assert_success
	assert_output "amd64"
}

@test "get_arch should support amd64" {
	stub uname "-m : echo 'amd64'"
	run get_arch

	assert_success
	assert_output "amd64"
}

@test "get_arch should support arm64" {
	stub uname "-m : echo 'arm64'"
	run get_arch

	assert_success
	assert_output "arm64"
}

@test "get_arch should support aarch64" {
	stub uname "-m : echo 'aarch64'"
	run get_arch

	assert_success
	assert_output "arm64"
}

@test "get_arch should support armv8" {
	stub uname "-m : echo 'armv8'"
	run get_arch

	assert_success
	assert_output "arm64"
}

@test "get_arch should not support any other architecture" {
	stub uname "-m : echo 'x86'"
	run get_arch

	assert_output "NOT_SUPPORTED"
}

@test "get_arch_regexp_part should return proper string for amd64 architecture" {
	stub uname "-m : echo 'amd64'"
	run get_arch_regexp_part

	assert_success
	assert_output '[._-](amd64|x86_64|x64|universal)'
}

@test "get_arch_regexp_part should return proper string for arm64 architecture" {
	stub uname "-m : echo 'armv8'"
	run get_arch_regexp_part

	assert_success
	assert_output '[._-](arm64|aarch64|universal)'
}

@test "get_arch_regexp_part should exit with error code" {
	stub uname "-m : echo 'x86'"
	run get_arch_regexp_part

	assert_failure 11
	assert_output --partial 'Error: Your CPU/OS architecture is not supported'
}

@test "get_filename_regexp should return proper string for linux/amd64" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
		
	run get_filename_regexp

	assert_success
	assert_output '([a-z][a-z0-9_-]+?)([_-]v?[0-9.]+)?([._-](unknown[._-])?(linux|linux-gnu|linux-musl)[._-](amd64|x86_64|x64|universal)|[._-](amd64|x86_64|x64|universal)[._-](unknown[._-])?(linux|linux-gnu|linux-musl))(\.zip|\.tar\.gz|\.tar\.xz|\.tar\.bz2)?'
}

@test "get_filename_regexp should return proper string for linux/arm64" {
	stub uname \
		"-s : echo 'Linux-gnu'" \
		"-m : echo 'aarch64'"
		
	run get_filename_regexp

	assert_success
	assert_output '([a-z][a-z0-9_-]+?)([_-]v?[0-9.]+)?([._-](unknown[._-])?(linux|linux-gnu|linux-musl)[._-](arm64|aarch64|universal)|[._-](arm64|aarch64|universal)[._-](unknown[._-])?(linux|linux-gnu|linux-musl))(\.zip|\.tar\.gz|\.tar\.xz|\.tar\.bz2)?'
}

@test "get_filename_regexp should return proper string for macos/amd64" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'amd64'"
		
	run get_filename_regexp

	assert_success
	assert_output '([a-z][a-z0-9_-]+?)([_-]v?[0-9.]+)?([._-](apple[._-])?(darwin|macos|osx)[._-](amd64|x86_64|x64|universal)|[._-](amd64|x86_64|x64|universal)[._-](apple[._-])?(darwin|macos|osx))(\.zip|\.tar\.gz|\.tar\.xz|\.tar\.bz2)?'
}

@test "get_filename_regexp should return proper string for macos/arm64" {
	stub uname \
		"-s : echo 'Darwin 19.0.1'" \
		"-m : echo 'arm64'"
		
	run get_filename_regexp

	assert_success
	assert_output '([a-z][a-z0-9_-]+?)([_-]v?[0-9.]+)?([._-](apple[._-])?(darwin|macos|osx)[._-](arm64|aarch64|universal)|[._-](arm64|aarch64|universal)[._-](apple[._-])?(darwin|macos|osx))(\.zip|\.tar\.gz|\.tar\.xz|\.tar\.bz2)?'
}

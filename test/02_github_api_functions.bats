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

@test "fetch_release_info should print an error message if the release info cannot be fetched" {
	stub curl "-s * : cat '$DIR/test/fixtures/releases/_error/release.json'"

	TEST_TEMP_DIR=$(mktemp -d)
	cd "$TEST_TEMP_DIR"

	run fetch_release_info

	assert_failure 13
	assert_output --partial "Error: Couldn't fetch release information."
	assert_output --partial "Response from GitHub API: [419] I'm a teapot"
}

# --- argocd tests ---

@test "find_download_url should print match for the correct asset [argocd/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/argocd/release.json"

	assert_success
	assert_output "https://github.com/argoproj/argo-cd/releases/download/v2.13.1/argocd-linux-amd64"
}

@test "find_download_url should print match for the correct asset [argocd/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/argocd/release.json"

	assert_success
	assert_output "https://github.com/argoproj/argo-cd/releases/download/v2.13.1/argocd-linux-arm64"
}

@test "find_download_url should print match for the correct asset [argocd/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/argocd/release.json"

	assert_success
	assert_output "https://github.com/argoproj/argo-cd/releases/download/v2.13.1/argocd-darwin-amd64"
}

@test "find_download_url should print match for the correct asset [argocd/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/argocd/release.json"

	assert_success
	assert_output "https://github.com/argoproj/argo-cd/releases/download/v2.13.1/argocd-darwin-arm64"
}

# --- gh tests ---

@test "find_download_url should print match for the correct asset [gh/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/gh/release.json"

	assert_success
	assert_output "https://github.com/cli/cli/releases/download/v2.63.0/gh_2.63.0_linux_amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [gh/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/gh/release.json"

	assert_success
	assert_output "https://github.com/cli/cli/releases/download/v2.63.0/gh_2.63.0_linux_arm64.tar.gz"
}

@test "find_download_url should print match for the correct asset [gh/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/gh/release.json"

	assert_success
	assert_output "https://github.com/cli/cli/releases/download/v2.63.0/gh_2.63.0_macOS_amd64.zip"
}

@test "find_download_url should print match for the correct asset [gh/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/gh/release.json"

	assert_success
	assert_output "https://github.com/cli/cli/releases/download/v2.63.0/gh_2.63.0_macOS_arm64.zip"
}

# --- goss tests ---

@test "find_download_url should print match for the correct asset [goss/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/goss/release.json"

	assert_success
	assert_output "https://github.com/goss-org/goss/releases/download/v0.4.9/goss-linux-amd64"
}

@test "find_download_url should print match for the correct asset [goss/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/goss/release.json"

	assert_success
	assert_output "https://github.com/goss-org/goss/releases/download/v0.4.9/goss-linux-arm64"
}

@test "find_download_url should print match for the correct asset [goss/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/goss/release.json"

	assert_success
	assert_output "https://github.com/goss-org/goss/releases/download/v0.4.9/goss-darwin-amd64"
}

@test "find_download_url should print match for the correct asset [goss/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/goss/release.json"

	assert_success
	assert_output "https://github.com/goss-org/goss/releases/download/v0.4.9/goss-darwin-arm64"
}

# --- helm tests ---

@test "find_download_url should print match for the correct asset [helm/linux/amd64]" {
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

@test "find_download_url should print match for the correct asset [helm/linux/arm64]" {
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

@test "find_download_url should print match for the correct asset [helm/macos/amd64]" {
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

@test "find_download_url should print match for the correct asset [helm/macos/arm64]" {
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

# --- k9s tests ---

@test "find_download_url should print match for the correct asset [k9s/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/k9s/release.json"

	assert_success
	assert_output "https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_Linux_amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [k9s/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/k9s/release.json"

	assert_success
	assert_output "https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_Linux_arm64.tar.gz"
}

@test "find_download_url should print match for the correct asset [k9s/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/k9s/release.json"

	assert_success
	assert_output "https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_Darwin_amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [k9s/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/k9s/release.json"

	assert_success
	assert_output "https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_Darwin_arm64.tar.gz"
}

# --- kops tests ---

@test "find_download_url should print match for the correct asset [kops/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/kops/release.json"

	assert_success
	assert_output "https://github.com/kubernetes/kops/releases/download/v1.30.2/channels-linux-amd64
https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64
https://github.com/kubernetes/kops/releases/download/v1.30.2/nodeup-linux-amd64
https://github.com/kubernetes/kops/releases/download/v1.30.2/protokube-linux-amd64"
}

@test "find_download_url should print match for the correct asset [kops/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/kops/release.json"

	assert_success
	assert_output "https://github.com/kubernetes/kops/releases/download/v1.30.2/channels-linux-arm64
https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-arm64
https://github.com/kubernetes/kops/releases/download/v1.30.2/nodeup-linux-arm64
https://github.com/kubernetes/kops/releases/download/v1.30.2/protokube-linux-arm64"
}

@test "find_download_url should print match for the correct asset [kops/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/kops/release.json"

	assert_success
	assert_output "https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-darwin-amd64"
}

@test "find_download_url should print match for the correct asset [kops/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/kops/release.json"

	assert_success
	assert_output "https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-darwin-arm64"
}

# --- terragrunt tests ---

@test "find_download_url should print match for the correct asset [terragrunt/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/terragrunt/release.json"

	assert_success
	assert_output "https://github.com/gruntwork-io/terragrunt/releases/download/v0.69.3/terragrunt_linux_amd64"
}

@test "find_download_url should print match for the correct asset [terragrunt/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/terragrunt/release.json"

	assert_success
	assert_output "https://github.com/gruntwork-io/terragrunt/releases/download/v0.69.3/terragrunt_linux_arm64"
}

@test "find_download_url should print match for the correct asset [terragrunt/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/terragrunt/release.json"

	assert_success
	assert_output "https://github.com/gruntwork-io/terragrunt/releases/download/v0.69.3/terragrunt_darwin_amd64"
}

@test "find_download_url should print match for the correct asset [terragrunt/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/terragrunt/release.json"

	assert_success
	assert_output "https://github.com/gruntwork-io/terragrunt/releases/download/v0.69.3/terragrunt_darwin_arm64"
}

# --- trufflehog tests ---

@test "find_download_url should print match for the correct asset [trufflehog/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/trufflehog/release.json"

	assert_success
	assert_output "https://github.com/trufflesecurity/trufflehog/releases/download/v3.84.2/trufflehog_3.84.2_linux_amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [trufflehog/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/trufflehog/release.json"

	assert_success
	assert_output "https://github.com/trufflesecurity/trufflehog/releases/download/v3.84.2/trufflehog_3.84.2_linux_arm64.tar.gz"
}

@test "find_download_url should print match for the correct asset [trufflehog/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/trufflehog/release.json"

	assert_success
	assert_output "https://github.com/trufflesecurity/trufflehog/releases/download/v3.84.2/trufflehog_3.84.2_darwin_amd64.tar.gz"
}

@test "find_download_url should print match for the correct asset [trufflehog/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/trufflehog/release.json"

	assert_success
	assert_output "https://github.com/trufflesecurity/trufflehog/releases/download/v3.84.2/trufflehog_3.84.2_darwin_arm64.tar.gz"
}

# --- sops tests ---

@test "find_download_url should print match for the correct asset [sops/linux/amd64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/sops/release.json"

	assert_success
	assert_output "https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.linux.amd64"
}

@test "find_download_url should print match for the correct asset [sops/linux/arm64]" {
	stub uname \
		"-s : echo 'Linux'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/sops/release.json"

	assert_success
	assert_output "https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.linux.arm64"
}

@test "find_download_url should print match for the correct asset [sops/macos/amd64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'x86_64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/sops/release.json"

	assert_success
	assert_output "https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.darwin.amd64"
}

@test "find_download_url should print match for the correct asset [sops/macos/arm64]" {
	stub uname \
		"-s : echo 'Darwin'" \
		"-m : echo 'aarch64'"
	
	DEBUG=""
	run find_download_url "$DIR/test/fixtures/releases/sops/release.json"

	assert_success
	assert_output "https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.darwin.arm64"
}

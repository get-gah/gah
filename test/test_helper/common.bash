DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." >/dev/null 2>&1 && pwd)"
PATH="$DIR/..:$PATH"

function common_setup() {
	DEBUG="true"
}

function common_teardown() {
	DEBUG=""
}

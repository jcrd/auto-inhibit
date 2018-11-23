#!/bin/sh

test_description='Test auto-inhibit'

. ./sharness/sharness.sh

# leave sharness directory
cd ..

SHARNESS_TEST_DIRECTORY="$(pwd)"

TMPDIR="$SHARNESS_TRASH_DIRECTORY"

# abort if `iniq` dependency is not found
which iniq > /dev/null || exit 1

export AUTO_INHIBIT_CONF="$(readlink -f test.conf)"
export AUTO_INHIBIT_CMD="$(readlink -f test-inhibit.sh)"
export AUTO_INHIBITOR="$(which auto-inhibit)"

mkdir "$TMPDIR"/check

test_expect_success 'Ensure auto-inhibit check works' '
ln -s "$AUTO_INHIBITOR" "$TMPDIR"/check/true &&
ln -s "$AUTO_INHIBITOR" "$TMPDIR"/check/false &&
auto-inhibit -d "$TMPDIR/check" check
'

test_expect_success 'Generate symlinks' '
auto-inhibit -d "$TMPDIR" generate &&
auto-inhibit -d "$TMPDIR" check
'

test_expect_success 'List symlinks' '
test "$(auto-inhibit -d "$TMPDIR" list)" = "false
true"
'

test_expect_success 'Use symlink' '
test "$("$TMPDIR"/true)" = "--why=Testing /usr/bin/true"
'

test_expect_success 'Remove symlinks' '
auto-inhibit -d "$TMPDIR" remove &&
test_expect_code 2 auto-inhibit -d "$TMPDIR" check
'

test_done

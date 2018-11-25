#!/bin/sh

test_description='Test auto-inhibit'

. ./sharness/sharness.sh

# abort if `iniq` dependency is not found
which iniq > /dev/null || exit 1

export AUTO_INHIBIT_CONF="$SHARNESS_TEST_DIRECTORY"/test.conf
export AUTO_INHIBIT_CMD="$SHARNESS_TEST_DIRECTORY"/test-inhibit.sh
export AUTO_INHIBITOR="$(which auto-inhibit)"

mkdir checkdir

test_expect_success 'Ensure auto-inhibit check works' '
ln -s "$AUTO_INHIBITOR" checkdir/true &&
ln -s "$AUTO_INHIBITOR" checkdir/false &&
auto-inhibit -d checkdir check
'

test_expect_success 'Ensure failed check has correct exit code' '
test_expect_code 2 auto-inhibit -d . check
'

test_expect_success 'Generate symlinks' '
auto-inhibit -d . generate &&
auto-inhibit -d . check
'

test_expect_success 'List symlinks' '
test "$(auto-inhibit -d . list)" = "false
true"
'

test_expect_success 'Use symlink' '
test "$(./true)" = "--why=Testing /usr/bin/true"
'

test_expect_success 'Remove symlinks' '
auto-inhibit -d . remove &&
test_expect_code 2 auto-inhibit -d . check
'

test_done

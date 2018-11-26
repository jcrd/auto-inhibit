#!/bin/sh

test_description='Test auto-inhibit'

. ./sharness/sharness.sh

# abort if `iniq` dependency is not found
command -v iniq > /dev/null || exit 1

export AUTO_INHIBIT_CONF="$SHARNESS_TEST_DIRECTORY"/test.conf
export AUTO_INHIBIT_CMD="$SHARNESS_TEST_DIRECTORY"/test-inhibit.sh
export AUTO_INHIBITOR="$(command -v auto-inhibit)"

mkdir checkdir

test_expect_success 'Ensure auto-inhibit check works' '
ln -s "$AUTO_INHIBITOR" checkdir/env &&
ln -s "$AUTO_INHIBITOR" checkdir/who &&
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
test "$(auto-inhibit -d . list)" = "env
who"
'

test_expect_success 'Use symlink' '
test "$(./env)" = "--why=Testing /usr/bin/env"
'

test_expect_success 'Remove symlinks' '
auto-inhibit -d . remove &&
test_expect_code 2 auto-inhibit -d . check
'

test_done

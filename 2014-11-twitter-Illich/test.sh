#!/bin/bash

SAVE_OUTPUT="$1"

set -e

if [ !"$TEST_STR" ]; then
	TEST_STR=`cat test-input.txt`
fi

echo '=== TEST_STR - begin =============================================='
echo "$TEST_STR"
echo '=== TEST_STR - end ================================================'
echo

echo '=== original: ==='
echo $TEST_STR | ./source.pl

echo ''

echo '=== demystified: ==='
echo $TEST_STR | ./demystified.pl

if [ "$SAVE_OUTPUT" ]; then
	echo $TEST_STR | ./demystified.pl 2>&1 > test-output.txt
fi

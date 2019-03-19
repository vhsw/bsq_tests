#!/bin/sh

BSQ=~/clorelei/BSQ/bsq
TEST_DIR=tests

passed_tests=1
for file in $TEST_DIR/*.map; do
	DIFF=$($BSQ $file 2>&1 | diff ${file%.map}.output -)
	if [ -z "$DIFF" ]
	then
		echo "$file OK"
	else
		echo "$file FAIL"
		echo "$DIFF"
		# exit 1
	fi
	passed_tests=$((passed_tests+1))
done
exit 0

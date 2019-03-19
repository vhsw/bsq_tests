#!/bin/bash

BSQ=../BSQ/bsq
TEST_DIR=tests

MAP_GENERATOR=./map_generator.pl
passed_tests=1
FILE_ERROR="map error" # "wrong file path"
MAP_ERROR="map error"

for file in $TEST_DIR/*.map; do
	DIFF=$($BSQ $file 2>&1 | diff ${file%.map}.output -)
	if [ -z "$DIFF" ]
	then
		echo "OK $file"
	else
		echo "FAIL $file"
		echo "$DIFF"
		exit 1
	fi
	passed_tests=$((passed_tests+1))
done

OUT=$($BSQ jaosjdfoajrotiasdgaergwasdf 2>&1 > /dev/null )
if [ "$OUT" == "$FILE_ERROR" ]
then
	echo "OK missing file"
else
	echo "FAIL missing file"
	echo "$OUT"
	exit 1
fi

OUT=$($BSQ / 2>&1 > /dev/null )
if [ "$OUT" == "$FILE_ERROR" ]
then
	echo "OK dir"
else
	echo "FAIL dir"
	echo "$OUT"
	exit 1
fi

for i in {1..100}
do
	$MAP_GENERATOR $i $i $i | $BSQ
	$MAP_GENERATOR $i $i $((i/10)) | $BSQ
	$MAP_GENERATOR $i $i 0 | $BSQ
	echo "OK map $i $i $((i/10))"
done

# uncomment if you wanna make you computer cry
for i in 100 1000 # 10000
do
	$MAP_GENERATOR 1 $i 0 | $BSQ
	$MAP_GENERATOR 1 $i $((i/10)) | $BSQ
	$MAP_GENERATOR 1 $i $i | $BSQ
	echo "OK map 1 $i"

	$MAP_GENERATOR $i 1 0 | $BSQ
	$MAP_GENERATOR $i 1 $((i/10)) | $BSQ
	$MAP_GENERATOR $i 1 $i | $BSQ
	echo "OK map $i 1"

	$MAP_GENERATOR $i $i 0 | $BSQ
	$MAP_GENERATOR $i $i $((i/10)) | $BSQ
	$MAP_GENERATOR $i $i $i | $BSQ
	echo "OK map $i $i"
done
echo "ALL TESTS PASS"
exit 0

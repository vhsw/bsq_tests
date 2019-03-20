#!/bin/bash

BSQ=./bsq

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TEST_DIR=$DIR/tests
MAP_GENERATOR=$DIR/map_generator.pl
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

DIFF=$($BSQ $TEST_DIR/*.map 2>&1 | diff $TEST_DIR/multiple.output - )
if [ -z "$DIFF" ]
then
	echo "OK multiple files"
else
	echo "FAIL multiple files"
	echo "$DIFF"
	exit 1
fi

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

echo "Tesing random maps. It might take some time..."
for i in {1..99}
do
	printf "\rMap size $i\r"
	if	[ $($MAP_GENERATOR $i $i $i | $BSQ | wc -c) != $((($i + 1) * $i)) ] || \
		[ $($MAP_GENERATOR $i $i $((i/10)) | $BSQ | wc -c) != $((($i + 1) * $i)) ] || \
		[ $($MAP_GENERATOR $i $i 0 | $BSQ | wc -c) != $((($i + 1) * $i)) ]
	then
		echo "FAIL Map $i x $i"
		exit 1
	fi
	
done
echo "OK random maps"
echo "Tesing big maps. It might take some time..."
# uncomment if you wanna make you computer cry
for i in 100 1000 # 10000
do
	printf "\rMap size $i\r"
	if	[ $($MAP_GENERATOR 1 $i $i | $BSQ | wc -c) != $(((1 + 1) * $i)) ] || \
		[ $($MAP_GENERATOR 1 $i $((i/10)) | $BSQ | wc -c) != $(((1 + 1) * $i)) ] || \
		[ $($MAP_GENERATOR 1 $i 0 | $BSQ | wc -c) != $(((1 + 1) * $i)) ] || \
		[ $($MAP_GENERATOR $i 1 1 | $BSQ | wc -c) != $((($i + 1) * 1)) ] || \
		[ $($MAP_GENERATOR $i 1 0 | $BSQ | wc -c) != $((($i + 1) * 1)) ] || \
		[ $($MAP_GENERATOR $i $i $i | $BSQ | wc -c) != $((($i + 1) * $i)) ] || \
		[ $($MAP_GENERATOR $i $i $((i/10)) | $BSQ | wc -c) != $((($i + 1) * $i)) ] || \
		[ $($MAP_GENERATOR $i $i 0 | $BSQ | wc -c) != $((($i + 1) * $i)) ]
	then
		echo "FAIL Map $i x $i"
		exit 1
	fi
done
echo "OK big maps   "
echo "ALL TESTS PASS"
exit 0

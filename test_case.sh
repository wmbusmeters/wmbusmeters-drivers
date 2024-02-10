#!/bin/bash

TEST=build/test

PROG="$1"
DRIVER="$2"
ARGS="$3"
HEX="$4"
JSON="$5"
FIELDS="$6"

rm -f $TEST/test_output.txt $TEST/test_expected.txt

$PROG --driver=$DRIVER --format=json $HEX $ARGS \
    | jq . --sort-keys \
    | sed 's/"timestamp": "....-..-..T..:..:..Z"/"timestamp": "1111-11-11T11:11:11Z"/' \
    > $TEST/test_output.txt

echo "$JSON" | jq . --sort-keys > $TEST/test_expected.txt

if ! diff $TEST/test_expected.txt $TEST/test_output.txt
then
    if [ "$USE_MELD" = "true" ]
    then
        meld $TEST/test_expected.txt $TEST/test_output.txt
    fi
fi

rm -f $TEST/test_output.txt $TEST/test_expected.txt

$PROG --driver=$DRIVER --format=fields $HEX $ARGS \
    | sed 's/....-..-.. ..:..:../1111-11-11 11:11.11/' \
    > $TEST/test_output.txt

echo "$FIELDS" > $TEST/test_expected.txt

if ! diff $TEST/test_expected.txt $TEST/test_output.txt
then
    if [ "$USE_MELD" = "true" ]
    then
        meld $TEST/test_expected.txt $TEST/test_output.txt
    fi
fi

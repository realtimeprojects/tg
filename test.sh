#!/bin/bash

mksource="$(pwd)/mksource";

function fail
{
    echo "ABORTING: $1";
    exit 1;
}

function assert
{
    echo -n "checking $1..."
    eval $1 || fail "TEST FAILED..aborting!";
    echo "OK";
}

function cleanup
{
    rm -f test/output/TestCreatePerlFile.pl;
}

function startup
{
    if [ ! -e test/output ]; then mkdir -p test/output; fi;
}

cleanup;
startup;

assert "[ -d test/output ]";
assert "$mksource -t perl -o test/output TestCreatePerlFile";
assert "[ -e test/output/TestCreatePerlFile.pl ]";



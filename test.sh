#!/bin/bash

### (((1 mksource automated test
#
# This script automatically tests the mksource projects.
#
# Test output files will be written to the test/output directory. test.sh creates this directory, if it does not
# exists. The tests check correct functionality of mksource.
###

mksource="$(pwd)/mksource";

### {{{1 testing tools

### {{{2 function fail - abort the script with an error message
function fail
{
    echo "ABORTING: $1";
    exit 1;
}

### {{{2 function assert - check a condition and fail if it is not fulfilled
function assert
{
    echo -n "checking $1..."
    eval $1 || fail "TEST FAILED..aborting!";
    echo "OK";
}

### {{{1 test helper functions

### {{{2 function cleanup - cleanup test environment
function cleanup
{
    rm -f test/output/TestCreatePerlFile.pl;
}

### {{{2 function startup - prepare the tests
function startup
{
    if [ ! -e test/output ]; then mkdir -p test/output; fi;
}

cleanup;
startup;
export MKSOURCE_TMPLDIR=./examples/templates

assert "[ -d test/output ]";
assert "$mksource -t perl -o test/output TestCreatePerlFile";
assert "grep -q TestCreatePerlFile test/output/TestCreatePerlFile.pl";
assert "grep author test/output/TestCreatePerlFile.pl | grep -q $LOGNAME";
assert "[ -e test/output/TestCreatePerlFile.pl ]";



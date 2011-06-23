#!/bin/bash
###
#
# mksource - automated test script
#
# Copyright:
# 
# (2011) - Claudio Klingler - realtime projects -
#
# License:
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
    rm -f test/output/TestCreateOverWrittenUserName.pl;
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

# test overwriting user name
assert "$mksource -t perl -u overwritten_user_name -o test/output TestCreateOverWrittenUserName"
assert "grep -q overwritten_user_name test/output/TestCreateOverWrittenUserName.pl";

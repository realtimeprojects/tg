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

### {{{2 function assert - check a condition and fail if it is not fulfilled
function assert_false
{
    echo -n "checking (!) $1..."
    eval $1 && fail "TEST FAILED..aborting!";
    echo "OK";
}
### {{{1 test helper functions

### {{{2 function cleanup - cleanup test environment
function cleanup
{
    rm -f test/output/TestCreatePerlFile.pl;
    rm -f test/output/TestCreateOverWrittenUserName.pl;
    rm -f test/output/CppMultiple.cpp;
    rm -f test/output/CppMultiple.h;
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

# test force overwriting
assert "$mksource -t perl -f -u YYY -o test/output TestCreatePerlFile";
assert "grep -q YYY test/output/TestCreatePerlFile.pl";
assert_false "$mksource -t perl -u ZZZ -o test/output TestCreatePerlFile >/dev/null";
assert_false "grep -q ZZZ test/output/TestCreatePerlFile.pl";

# test multiple source without configuration
assert "[ -e examples/templates/cpp/@Target@.cpp ]";
assert "[ -e examples/templates/cpp/@Target@.h ]";
assert "$mksource -t cpp -o test/output CppMultiple"
assert "grep -q CppMultiple test/output/CppMultiple.cpp";
assert "grep -q CppMultiple test/output/CppMultiple.h";

# test list function for bash completion
assert "$mksource --list | grep -q cpp"
assert "$mksource --list | grep -q perl"

# test the --show_args for bash completion
assert "$mksource --show_args | grep -q show_args"; 
assert "$mksource --show_args | grep -q force"; 
assert "$mksource --show_args | grep -q template"; 
assert "$mksource --show_args | grep -q user"; 
assert "$mksource --show_args | grep -q output"; 
assert "$mksource --show_args | grep -q help"; 
assert "$mksource --show_args | grep -q verbose"; 
assert "$mksource --show_args | grep -q debug"; 

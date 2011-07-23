#!/bin/bash
###
#
# tg - automated test script
#
# Copyright (c) 2011, Claudio Klingler, realtime projects
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
# - Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
#
# HIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
## (((1 tg automated test
#
# This script automatically tests the tg projects.
#
# Test output files will be written to the test/output directory. test.sh creates this directory, if it does not
# exists. The tests check correct functionality of tg.
###

tg="$(pwd)/tg";

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
    rm -f test/output/TestCreatePerlFile2.pl;
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
export TG_TMPLDIR=./examples/templates

assert "[ -d test/output ]";

# test template creatin with "using"
assert "$tg -o test/output create TestCreatePerlFile using perl";
assert "grep -q TestCreatePerlFile test/output/TestCreatePerlFile.pl";
assert "grep author test/output/TestCreatePerlFile.pl | grep -q $LOGNAME";
assert "[ -e test/output/TestCreatePerlFile.pl ]";

# test template creation with -t
assert "$tg -o test/output -t perl create TestCreatePerlFile2";
assert "grep -q TestCreatePerlFile test/output/TestCreatePerlFile2.pl";
assert "grep author test/output/TestCreatePerlFile2.pl | grep -q $LOGNAME";
assert "[ -e test/output/TestCreatePerlFile2.pl ]";
assert "[ -e test/output/TestCreatePerlFile2.pl ]";

# test overwriting user name
assert "$tg -u overwritten_user_name -o test/output create TestCreateOverWrittenUserName using perl"
assert "grep -q overwritten_user_name test/output/TestCreateOverWrittenUserName.pl";

# test force overwriting
assert "$tg -f -u YYY -o test/output create TestCreatePerlFile perl";
assert "grep -q YYY test/output/TestCreatePerlFile.pl";
assert_false "$tg -u ZZZ -o test/output create TestCreatePerlFile using perl >/dev/null";
assert_false "grep -q ZZZ test/output/TestCreatePerlFile.pl";

# test multiple source without configuration
assert "[ -e examples/templates/cpp/@Target@.cpp ]";
assert "[ -e examples/templates/cpp/@Target@.h ]";
assert "$tg -o test/output create CppMultiple using cpp"
assert "grep -q CppMultiple test/output/CppMultiple.cpp";
assert "grep -q CppMultiple test/output/CppMultiple.h";

# test list function for bash completion
assert "$tg list | grep -q cpp"
assert "$tg list | grep -q perl"

# test the --showargs for bash completion
assert "$tg showargs | grep -q showargs"; 
assert "$tg showargs | grep -q force"; 
assert "$tg showargs | grep -q template"; 
assert "$tg showargs | grep -q user"; 
assert "$tg showargs | grep -q output"; 
assert "$tg showargs | grep -q help"; 
assert "$tg showargs | grep -q verbose"; 
assert "$tg showargs | grep -q debug"; 
assert "$tg showargs | grep -q version"; 

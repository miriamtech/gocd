#!/bin/bash -e
#
# Invoke me from Atom with:
#    All:       bin/run_tests.sh
#    File:      bin/run_tests.sh {relative_path}
#    Single:    bin/run_tests.sh {relative_path} {line_number} "{regex}"

FILENAME=$1
LINE_NUMBER=$2
TEST_NAME=$3

COMMAND="ruby -Itest"
export BUILD_TAG=""

if [ ! -z "${TEST_NAME}" ]; then
  if [[ "${TEST_NAME}" =~ 'test_' ]]; then
    METHOD_NAME=${TEST_NAME}
  else
    METHOD_NAME=test_${TEST_NAME//[[:space:]]/_}
  fi
  echo "Running: ${METHOD_NAME}"
  ${COMMAND} ${FILENAME} --name "${METHOD_NAME}"
elif [ ! -z "${FILENAME}" ]; then
  ${COMMAND} ${FILENAME}
else
  rake
fi

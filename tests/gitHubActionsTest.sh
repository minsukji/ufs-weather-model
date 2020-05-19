#!/bin/bash
cat UnitTests_linux.gnu.log

if grep --quiet 'UNIT TEST WAS SUCCESSFUL' UnitTests_linux.gnu.log; then
  exit 0
else
  exit 1
fi

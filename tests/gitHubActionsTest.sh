#!/bin/bash
cat UnitTests_hera.intel.log

if grep --quiet 'UNIT TEST WAS SUCCESSFUL' UnitTests_hera.intel.log; then
  exit 0
else
  exit 1
fi

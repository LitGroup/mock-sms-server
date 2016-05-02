#!/usr/bin/env bash

# Verify that the libraries are error free.
pub global activate tuneup
pub global run tuneup check

# Verify code style.
# pub global activate linter
# pub global run linter ./

# Run the tests.
pub run test --reporter=expanded --no-color

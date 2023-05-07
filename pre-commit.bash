#!/bin/bash

# Dart formatter
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter Formatter ==='
dart format .
if [ ! $? ]; then
    echo "COMMIT REJECTED: Dart Format found errors"
    exit 1
fi

# Dart Fix -> Fix code issues that are fixable
printf "\e[33;1m%s\e[0m\n" '=== Running Dart Fix ==='
dart fix --apply
if [ ! $? ]; then
    echo "COMMIT REJECTED: Dart analyze found the following errors:"
    exit 1
fi

# Run Dart analyze and check for errors
printf "\e[33;1m%s\e[0m\n" '=== Running Dart Analyse to check for remaning errors ==='
if ! output=$(dart analyze); then
    echo "COMMIT REJECTED: Dart analyze found the following errors:"
    echo "$output"
    exit 1
fi

# If we made it this far, the commit is allowed
echo "Success!"
exit 0
#!/bin/bash
# Script to capture and display detailed build logs from the CI environment

echo "========================================================"
echo "          CAPTURING DETAILED CI BUILD LOGS              "
echo "========================================================"

LOGS_DIR="${1:-./artifacts/build-logs}"
mkdir -p "$LOGS_DIR"

echo ">> Searching for CMake & C++ compiler logs..."
find . -type f \( \
    -name "CMakeError.log" -o \
    -name "CMakeOutput.log" -o \
    -name "*.ninja_log" -o \
    -name "build.ninja.txt" -o \
    -name "compiler_depend.ts" \
\) -exec cp --parents {} "$LOGS_DIR/" 2>/dev/null || true

echo ">> Searching for Gradle logs & reports..."
find . -type d -name "reports" -exec cp -r --parents {} "$LOGS_DIR/" 2>/dev/null || true

echo ">> Printing recent errors found in logs:"
echo "--------------------------------------------------------"
find . -type f \( -name "CMakeError.log" -o -name "build.ninja.txt" -o -name "*.log" \) | while read -r logfile; do
    if [ -s "$logfile" ]; then
        echo "=== [LOG FILE: $logfile] ==="
        tail -n 120 "$logfile"
        echo "========================================================"
    fi
done

echo "--------------------------------------------------------"
echo "All captured logs have been archived into: $LOGS_DIR"

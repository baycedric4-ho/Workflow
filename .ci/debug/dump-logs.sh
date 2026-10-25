#!/bin/bash
# Script to capture and display detailed build logs from the CI environment

echo "========================================================"
echo "          CAPTURING DETAILED CI BUILD LOGS              "
echo "========================================================"

LOGS_DIR="${1:-./artifacts/build-logs}"
mkdir -p "$LOGS_DIR"

echo ">> System diagnostics:"
uname -a
echo "Java version:"
java -version 2>&1 || true

if [ -d "src/android" ]; then
    echo ">> Checking Gradle available tasks related to Android variants:"
    (cd src/android && ./gradlew tasks --all 2>/dev/null | grep -E "copy|assemble|build" | head -n 40) || true
fi

echo ">> Searching for CMake & C++ compiler logs..."
find . -type f \( \
    -name "CMakeError.log" -o \
    -name "CMakeOutput.log" -o \
    -name "*.ninja_log" -o \
    -name "build.ninja.txt" -o \
    -name "compiler_depend.ts" -o \
    -name "*.log" \
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

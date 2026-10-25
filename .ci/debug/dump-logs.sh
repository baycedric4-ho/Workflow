#!/bin/bash
# Script to capture and display detailed build logs from the CI environment

echo "========================================================"
echo "          CAPTURING DETAILED CI BUILD LOGS              "
echo "========================================================"

LOGS_DIR="${1:-./artifacts/build-logs}"
mkdir -p "$LOGS_DIR"

# 1. System and environment diagnostics report (ensures LOGS_DIR is never empty)
REPORT_FILE="$LOGS_DIR/diagnostic-summary.txt"
{
    echo "=== SYSTEM DIAGNOSTICS ==="
    uname -a
    echo "Date: $(date -u)"
    echo "Java Version:"
    java -version 2>&1 || true
    echo ""
    echo "=== WORKSPACE FILE TREE ==="
    find . -maxdepth 3 -not -path '*/.*' | head -n 100
    echo ""
    if [ -d "src/android" ]; then
        echo "=== GRADLE TASKS IN SRC/ANDROID ==="
        (cd src/android && ./gradlew tasks --all 2>&1 | head -n 150) || true
    fi
} > "$REPORT_FILE"

echo ">> System diagnostics written to $REPORT_FILE"

# 2. Check for gradle-build.log in root or src/android
for glog in "gradle-build.log" "src/android/gradle-build.log"; do
    if [ -f "$glog" ]; then
        echo ">> Found Gradle build log: $glog"
        cp "$glog" "$LOGS_DIR/"
        echo "=== [GRADLE LOG: $glog (tail 150 lines)] ==="
        tail -n 150 "$glog"
        echo "============================================"
    fi
done

# 3. Search for CMake & C++ compiler logs
echo ">> Searching for CMake & C++ compiler logs..."
find . -type f \( \
    -name "CMakeError.log" -o \
    -name "CMakeOutput.log" -o \
    -name "*.ninja_log" -o \
    -name "build.ninja.txt" -o \
    -name "compiler_depend.ts" -o \
    -name "*.log" \
\) -not -path "*/artifacts/*" | while read -r logfile; do
    if [ -f "$logfile" ]; then
        cp --parents "$logfile" "$LOGS_DIR/" 2>/dev/null || true
        if [ -s "$logfile" ]; then
            echo "=== [LOG FILE: $logfile (tail 80 lines)] ==="
            tail -n 80 "$logfile"
            echo "============================================"
        fi
    fi
done

# 4. Copy build reports
find . -type d -name "reports" -not -path "*/artifacts/*" -exec cp -r --parents {} "$LOGS_DIR/" 2>/dev/null || true

echo "--------------------------------------------------------"
echo "All captured logs have been archived into: $LOGS_DIR"
ls -la "$LOGS_DIR"

#!/bin/bash

# Build script for LARBenchmark macOS app
# Usage: ./build.sh [release|debug]

set -e  # Exit on error

# Determine configuration
CONFIG="${1:-debug}"
if [ "$CONFIG" == "release" ]; then
    CONFIGURATION="Release"
else
    CONFIGURATION="Debug"
fi

echo "============================================"
echo "Building LARBenchmark ($CONFIGURATION)"
echo "============================================"

# Build using xcodebuild
xcodebuild \
    -project LARBenchmark.xcodeproj \
    -scheme LARBenchmark \
    -configuration $CONFIGURATION \
    -destination 'platform=macOS' \
    build

echo ""
echo "✅ Build complete!"
echo ""
echo "To run the app:"
if [ "$CONFIGURATION" == "Release" ]; then
    echo "  open build/Release/LARBenchmark.app"
else
    echo "  open build/Debug/LARBenchmark.app"
fi
echo ""
echo "To profile with Instruments:"
echo "  1. Product → Profile (Cmd+I) in Xcode"
echo "  2. Select 'Metal System Trace' or 'Time Profiler'"
echo "  3. Run benchmark in the app"
echo ""

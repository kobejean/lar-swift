#!/bin/bash
# Build script for LocalizeAR using Apple Clang
# Usage: ./build.sh [clean|test|release]

set -e  # Exit on error

# Force Apple Clang
export CC=$(xcrun --find clang)
export CXX=$(xcrun --find clang++)

echo "============================================"
echo "Building LocalizeAR with Apple Clang"
echo "CC:  $CC"
echo "CXX: $CXX"
echo "============================================"

# Parse arguments
MODE="${1:-debug}"

case "$MODE" in
    clean)
        echo "Cleaning build artifacts..."
        swift package clean
        ;;
    test)
        echo "Building and running tests..."
        swift test
        ;;
    release)
        echo "Building release version..."
        swift build -c release
        ;;
    debug|*)
        echo "Building debug version..."
        swift build
        ;;
esac

echo ""
echo "✅ Build complete!"

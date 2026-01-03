#!/bin/bash
# Build script for LARExplorer using Apple Clang
# Usage: ./build.sh [clean|release]

set -e  # Exit on error

# Force Apple Clang (prevents Xcode from picking up gcc-12)
export CC=$(xcrun --find clang)
export CXX=$(xcrun --find clang++)

echo "============================================"
echo "Building LARExplorer with Apple Clang"
echo "CC:  $CC"
echo "CXX: $CXX"
echo "============================================"

# Parse arguments
MODE="${1:-debug}"

# LARExplorer project path
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEME="LARExplorer"
DESTINATION="platform=macOS"

case "$MODE" in
    clean)
        echo "Cleaning build artifacts..."
        xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" clean
        ;;
    release)
        echo "Building release version..."
        xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" -configuration Release build
        ;;
    test)
        echo "Running LARExplorer tests..."
        xcodebuild test -scheme "$SCHEME" -destination "$DESTINATION" -configuration Debug -only-testing:LARExplorerTests
        ;;
    debug|*)
        echo "Building debug version..."
        xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" -configuration Debug build
        ;;
esac

echo ""
echo "✅ Build complete!"

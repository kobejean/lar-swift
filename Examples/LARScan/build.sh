#!/bin/bash
# Build script for LARScan using Apple Clang
# Usage: ./build.sh [clean|release] [simulator|device]

set -e  # Exit on error

# Force Apple Clang (prevents Xcode from picking up gcc-12)
export CC=$(xcrun --find clang)
export CXX=$(xcrun --find clang++)

echo "============================================"
echo "Building LARScan with Apple Clang"
echo "CC:  $CC"
echo "CXX: $CXX"
echo "============================================"

# Parse arguments
MODE="${1:-debug}"
TARGET="${2:-simulator}"

# LARScan project path
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEME="LARScan"

# Select destination based on target
if [ "$TARGET" = "device" ]; then
    DESTINATION="generic/platform=iOS"
else
    DESTINATION="platform=iOS Simulator,name=iPhone 16 Pro"
fi

case "$MODE" in
    clean)
        echo "Cleaning build artifacts..."
        xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" clean
        ;;
    release)
        echo "Building release version for $TARGET..."
        xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" -configuration Release build
        ;;
    debug|*)
        echo "Building debug version for $TARGET..."
        xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" -configuration Debug build
        ;;
esac

echo ""
echo "✅ Build complete!"

---
allowed-tools: Bash(./build.sh:*), Bash(./Examples/LARExplorer/build.sh:*), Bash(./Examples/LARScan/build.sh:*)
argument-hint: [test|release|clean] [explorer]
description: Build LocalizeAR using build.sh (never use xcodebuild directly)
---

# /build Command

Build the LocalizeAR project using the appropriate build.sh script.

## Arguments: $ARGUMENTS

## Instructions

Parse the arguments and run the appropriate command:

### If "explorer" is in arguments:
- No mode or "debug": `./Examples/LARExplorer/build.sh`
- "test": `./Examples/LARExplorer/build.sh test`
- "release": `./Examples/LARExplorer/build.sh release`
- "clean": `./Examples/LARExplorer/build.sh clean`

### Otherwise (main library):
- No arguments or "debug": `./build.sh`
- "test": `./build.sh test`
- "release": `./build.sh release`
- "clean": `./build.sh clean`

## Examples

- `/build` → `./build.sh`
- `/build test` → `./build.sh test`
- `/build release` → `./build.sh release`
- `/build explorer` → `./Examples/LARExplorer/build.sh`
- `/build test explorer` → `./Examples/LARExplorer/build.sh test`

Run the command now.

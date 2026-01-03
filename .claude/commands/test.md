---
allowed-tools: Bash(./build.sh:*), Bash(./Examples/LARExplorer/build.sh:*), Bash(./Examples/LARScan/build.sh:*)
argument-hint: [explorer]
description: Run tests using build.sh (never use xcodebuild test directly)
---

# /test Command

Run tests for LocalizeAR using the appropriate build.sh script.

## Arguments: $ARGUMENTS

## Instructions

Parse the arguments and run the appropriate test command:

- If "explorer" is in arguments: `./Examples/LARExplorer/build.sh test`
- Otherwise (main library): `./build.sh test`

## Examples

- `/test` → `./build.sh test`
- `/test explorer` → `./Examples/LARExplorer/build.sh test`

Run the test command now.

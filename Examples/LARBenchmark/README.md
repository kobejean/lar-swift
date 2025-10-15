# LARBenchmark

macOS SwiftUI application for benchmarking GPU and multithreaded performance of the LocalizeAR (LAR) localization system.

## Purpose

LARBenchmark mirrors the behavior of the C++ `lar_localize` app but provides full Xcode Instruments integration for profiling:
- **Metal System Trace**: GPU timeline, L1 cache hits, kernel execution time
- **Time Profiler**: CPU usage per thread, hot paths
- **Allocations**: Memory growth and leak detection
- **Thread Sanitizer**: Race condition detection

## Features

- ✅ Multithreaded localization (1-16 threads)
- ✅ Staggered thread starts to avoid initialization spikes
- ✅ File picker UI for selecting map and frame directories
- ✅ Default paths: `./output/aizu-park-map/` and `./input/aizu-park-4-ext/`
- ✅ Real-time progress monitoring
- ✅ Detailed benchmark statistics (FPS, success rate, timing)
- ✅ Copy results to clipboard
- ✅ Full Xcode Instruments support

## Requirements

- **macOS**: 12.0+
- **Xcode**: 14.0+
- **Swift**: 5.5+
- **LocalizeAR Package**: Automatically resolved via SPM
- **Data**: Map and frame dataset (e.g., aizu-park-4-ext)

## Setup

### 1. Open Project in Xcode

```bash
open Examples/LARBenchmark/LARBenchmark.xcodeproj
```

### 2. Add LocalizeAR Package Dependency

If not already added:
1. File → Add Packages...
2. Enter local path: `../..` (points to lar-swift root)
3. Add Package

### 3. Configure Entitlements (for file access)

**For sandboxed app:**
- Enable "User Selected File" (Read Only) in entitlements

**For non-sandboxed app** (recommended for default paths):
- Signing & Capabilities → App Sandbox → OFF

### 4. Prepare Data

Ensure you have data in the expected locations:
```
./output/aizu-park-map/
├── map.json

./input/aizu-park-4-ext/
├── frames.json
├── 00000001_image.jpeg
├── 00000002_image.jpeg
└── ...
```

Or use the file picker to select custom directories.

## Usage

### Build and Run

**From Xcode:**
```bash
Product → Run (Cmd+R)
```

**From Command Line:**
```bash
cd Examples/LARBenchmark
./build.sh
open build/Debug/LARBenchmark.app
```

**Release Build:**
```bash
./build.sh release
open build/Release/LARBenchmark.app
```

### Running a Benchmark

1. **Select Directories** (or use defaults if available)
   - Map Directory: Contains `map.json`
   - Frames Directory: Contains `frames.json` and images

2. **Configure Settings**
   - Thread Count: 1-16 (default: 8)
   - Stagger Delay: 0-1000ms (default: 300ms)
   - Frame Limit: 10-2000 (default: 400)

3. **Start Benchmark**
   - Click "Start Benchmark"
   - Monitor real-time progress
   - View results when complete

4. **Copy Results**
   - Click "Copy Results" to copy formatted summary to clipboard

## Profiling with Xcode Instruments

### 1. Profile GPU Performance

```bash
Product → Profile (Cmd+I)
```

Select **Metal System Trace**:
- GPU Timeline: See compute kernel execution
- Buffer/Texture Activity: Monitor L1 cache hits
- Memory Bandwidth: Analyze throughput
- Shader Profiling: Identify bottlenecks

**Run the benchmark and observe:**
- Gaussian blur kernel timing
- DoG kernel timing
- L1 cache hit rates (buffer vs texture)
- GPU utilization percentage

### 2. Profile CPU Performance

Select **Time Profiler**:
- See CPU usage per thread
- Identify hot code paths
- Analyze thread contention
- Measure overhead of Swift/ObjC/C++ transitions

### 3. Test Buffer vs Texture Hypothesis

**Baseline (Texture-based Gaussian pyramid):**
```bash
# In sift_impl_metal.mm:21
#define USE_BUFFER_GAUSSIAN_PYRAMID 0

# Rebuild
cd ../..
./build.sh

# Run LARBenchmark, profile, record results
```

**Experimental (Buffer-based Gaussian pyramid):**
```bash
# In sift_impl_metal.mm:21
#define USE_BUFFER_GAUSSIAN_PYRAMID 1

# Rebuild
./build.sh

# Run LARBenchmark again, compare results
```

**Compare in Metal System Trace:**
- L1 cache hit rates
- Memory bandwidth utilization
- Kernel execution time
- Total frame processing time

## Architecture

```
LARBenchmark/
├── LARBenchmarkApp.swift           # @main entry point
├── Models/
│   ├── FrameData.swift              # Frame + image data
│   └── BenchmarkResults.swift       # Statistics container
├── Services/
│   ├── DataLoader.swift             # Load map.json + frames + images
│   ├── LocalizationWorker.swift     # Per-thread LARTracker wrapper
│   └── BenchmarkRunner.swift        # Multithreading orchestration
├── ViewModels/
│   └── BenchmarkViewModel.swift     # State management + file selection
└── Views/
    ├── ContentView.swift            # Main UI
    └── BenchmarkResultsView.swift   # Results display
```

### Key Design Decisions

1. **Actor-based DataLoader**: Thread-safe file loading
2. **Per-thread LocalizationWorker**: Each thread gets own LARTracker instance (not thread-safe)
3. **AtomicCounter**: Thread-safe progress tracking using `os_unfair_lock`
4. **Swift Concurrency**: Uses `async/await` and `TaskGroup` for multithreading
5. **File Picker**: NSOpenPanel for directory selection with defaults

## Benchmarking Workflow

### 1. Baseline Measurement
- Configuration: 8 threads, 300ms stagger, 400 frames
- Profile with Metal System Trace
- Record: FPS, L1 cache hits, kernel time

### 2. Thread Scaling Test
- Run with 1, 2, 4, 8, 16 threads
- Measure: Throughput scaling, GPU utilization

### 3. Stagger Delay Impact
- Test 0ms, 100ms, 300ms, 500ms
- Observe: Initialization spikes, stability

### 4. Buffer vs Texture Comparison
- Toggle `USE_BUFFER_GAUSSIAN_PYRAMID`
- Compare: Cache behavior, performance

## Interpreting Results

### Success Rate
- **>90%**: Good, map coverage is sufficient
- **70-90%**: Fair, may need more map coverage
- **<70%**: Poor, check data quality or tracker configuration

### Throughput (FPS)
- **Metal M1/M2**: Expect 5-15 FPS with 8 threads (varies by image size)
- **Intel**: Expect 2-8 FPS

### Thread Scaling
- **Linear**: 2x threads → ~2x throughput (ideal)
- **Sublinear**: 2x threads → <2x throughput (GPU bottleneck or overhead)
- **No scaling**: GPU is saturated, adding threads doesn't help

## Troubleshooting

### App won't launch
- Check that LocalizeAR package is properly linked
- Verify macOS version >= 12.0
- Check build configuration (Debug vs Release)

### "Directories not selected" error
- Click "Select..." buttons to choose directories
- Ensure directories contain map.json and frames.json
- Check file permissions

### No frames loaded
- Verify frames.json format matches LARFrame
- Check image filename format: `00000001_image.jpeg`
- Ensure images are readable (not corrupted)

### Metal errors in console
- Enable Metal validation in scheme: Edit Scheme → Run → Diagnostics → Metal API Validation
- Check for GPU driver issues
- Try reducing thread count

## Performance Tips

1. **Use Release builds** for profiling (Product → Scheme → Edit Scheme → Run → Release)
2. **Close other apps** to reduce GPU contention
3. **Use SSD** for faster image loading
4. **Limit frame count** for quick iterations
5. **Profile in batches** (don't run too many frames at once)

## Exporting Results

Results can be copied to clipboard as formatted text. For CSV export, you can modify `BenchmarkResults.swift` to add:

```swift
var csvRow: String {
    "\(totalFrames),\(successfulFrames),\(successRate),\(totalTime),\(averageTimePerFrame),\(throughputFPS),\(threadCount),\(staggerDelayMs)"
}
```

## Credits

Built for GPU and multithreading performance analysis of the LocalizeAR SLAM system.

---

**Next Steps:**
1. Open Xcode project
2. Run app
3. Profile with Instruments
4. Compare buffer vs texture implementations

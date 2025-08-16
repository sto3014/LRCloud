# LR/Cloud

# Status In Work

## Building and Installing

Ensure you have CMake installed before proceeding.

### Steps:
1. Clone the repository:
   ```sh
   git clone <repo-url>
   cd <repo-name>
   ```
2. Run the build script:
   ```sh
   chmod +x scripts/build.sh
   ./scripts/build.sh
   ```
3. Install plugin
   ```sh
   cp -r build/LRCloud.lrplugin ~/Library/Application\ Support/Adobe/Lightroom/Modules
   ```
4. Restart Lightroom


## Requirements
- macOS
- CMake
- Clang (default on macOS)

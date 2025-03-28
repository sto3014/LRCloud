# cloudfile

Cloud File CLI is a command-line utility for interacting with cloud-stored files on macOS. It allows users to materialize (download) or evict (remove locally while keeping in the cloud) files using Apple's `NSFileManager`.

## Usage

```sh
cloudfile <file-path> <command>
```

### Commands
- `materialize` - Downloads the file from the cloud
- `evict` - Removes the local copy while retaining it in the cloud

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
   chmod +x build.sh
   ./build.sh
   ```


## Requirements
- macOS
- CMake
- Clang (default on macOS)

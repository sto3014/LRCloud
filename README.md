# LR/Cloud

---
LR/Cloud is an Adobe Lightroom Classic plugin. It supports the handling of cloud-stored photos. It allows users to
download multiple photos or remove their local copy.

## Usage

---

There are two menu actions in the Library/Plug-in Extras submenu:

* Remove Downloads
* Download Photos

### Remove Downloads

Removes the local files of downloaded photos and only retains the link to the cloud.

### Download Photos

Download photo files that are only stored in the cloud.

## Use case

---

You keep your photos on a cloud drive like iCloud or OneDrive. Your photos are stored in folders that are organized by
date. You keep the photos of the current year permanently on your local drive. For all other years you removed the
download the spare disk space.

Maybe you find it helpful to have some Lightroom collections always available locally. Just select the photos of these
collections and press __Download Photos__.

If later your diskspace is getting too small you can created smart-previews for some collections and remove the
downloads by pressing __Remove Downloads__.

## Building and Installing

---

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

---

- Lightroom Classic
- macOS
- CMake
- Clang (default on macOS)

## Known issues

---

* If you remove downloads for photos that are kept permanently the content is deleted but immediately re-download.
* The download of photos doesn't keep them permanently. I.e., if your cloud service is configured to remove downloads
  to save disk space, your previously downloaded photos may be removed in the future.

## Acknowledgements

---

Special thanks to [Kevin Davis](https://github.com/kevincar) and his [cloudfile](https://github.com/kevincar/cloudfile)
project.
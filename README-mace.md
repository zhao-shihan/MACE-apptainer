# MACE offline software

## Contents

- [MACE offline software](#mace-offline-software)
  - [Contents](#contents)
  - [Quick start](#quick-start)
    - [How to pull](#how-to-pull)
    - [How to run](#how-to-run)
  - [Note](#note)
    - [Important note on ISX](#important-note-on-isx)
    - [Quick guide on ISX](#quick-guide-on-isx)
  - [Pull command list](#pull-command-list)
  - [Known issues](#known-issues)

## Quick start

### How to pull

**Pull the image by:**

- **`apptainer pull oras://docker.io/zhaoshh/mace:<isx><aux>`**
- **`<isx>` can be one of the followings: `avx2`, `avx`, `sse3`, and `tianhe2`.**
- **`<aux>` can be nothing or `-slim` (do not contain G4 data, smaller in size, but you need to install Geant4 data in your machine and setup environment variables).**

For example, `apptainer pull oras://docker.io/zhaoshh/mace:avx2` pulls down an image compiled with avx2 ISX, `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2-slim` pulls down an image specialized for Tianhe-2 and does not contain Geant4 data.

If you need a general-purposed image, and have no idea about CPU instruction sets, and you are not using an ancient computer (within 10 years), it is recommended to pull `avx2`:

- `apptainer pull oras://docker.io/zhaoshh/mace:avx2`

If you are going to run the image on Tianhe-2 supercomputer, here is a specialization:

- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2`

or with `-slim`, up to your purpose.

### How to run

The image contains MACE and its dependencies (including ROOT and Geant4 libraries).
You can run MACE simulation by `apptainer run`:

- `apptainer run rgb.sif SimMACE`
- `apptainer run rgb.sif SimTarget`
- `apptainer run rgb.sif SimEMC`

and it should show the SimMACE interface.
This image is built based on [RGB](https://hub.docker.com/r/zhaoshh/rgb), so **single-threaded** ROOT and Geant4 are also contained in this image, check them by

- `apptainer run rgb.sif root`
- `apptainer run rgb.sif geant4-config --version`

Common build tools like GCC, CMake, and Ninja are also provided:

- `apptainer run rgb.sif g++ --version`
- `apptainer run rgb.sif cmake --version`
- `apptainer run rgb.sif ninja --version`

Other usage should be the same as [RGB](https://hub.docker.com/r/zhaoshh/rgb).

## Note

### Important note on ISX

- **Select `<isx>` to the furthest extent that your CPU architecture supported can maximize performance, but do not use incompatible `<isx>` otherwise it will crash into `SIGILL` (Illegal Instruction)!**

- Use `lscpu` to view instruction sets available on your CPU. Its `Flags:` item will list all available instruction sets.

### Quick guide on ISX

- **`mace:avx2`** should be compatible to **x86-64 CPUs after 2015**: Intel CPU posterior to "Haswell" (posterior to Core i7-4XXX, Xeon E5-XXXX v3, etc.), AMD CPU posterior to "Bulldozer Gen4 (Excavator)". Compiled with `-mavx2 -mfma`.
- **`mace:avx`** should be compatible to **x86-64 CPUs after 2013**: Intel CPU posterior to "Sandy Bridge" (posterior to Core i7-2XXX, Xeon E5-XXXX, etc.), AMD CPU posterior to "Bulldozer Gen1". Compiled with `-mavx`.
- **`mace:sse3`** should be compatible to **x86-64 CPUs after 2006**: Intel CPU posterior to "Prescott" (posterior to Pentium 4, Celeron D etc.), AMD CPU posterior to "Athlon 64". Compiled with `-msse3`.
- **`mace:tianhe2`** is specialized for Intel "Ivy Bridge" architecture (used by **Tianhe-2 supercomputer**), and its content is specialized for its typical usage. Compiled with `-march=ivybridge`.

## Pull command list

- `apptainer pull oras://docker.io/zhaoshh/mace:avx2`
- `apptainer pull oras://docker.io/zhaoshh/mace:avx2-slim`
- `apptainer pull oras://docker.io/zhaoshh/mace:avx`
- `apptainer pull oras://docker.io/zhaoshh/mace:avx-slim`
- `apptainer pull oras://docker.io/zhaoshh/mace:sse3`
- `apptainer pull oras://docker.io/zhaoshh/mace:sse3-slim`
- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2`
- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2-slim`

## Known issues

- Stacktrace is currently not available (it will crash into bus error).

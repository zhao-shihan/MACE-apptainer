# MACE offline software apptainer container

## Contents

- [MACE offline software apptainer container](#mace-offline-software-apptainer-container)
  - [Contents](#contents)
  - [Quick start](#quick-start)
    - [How to pull](#how-to-pull)
    - [How to run](#how-to-run)
  - [Pull command list](#pull-command-list)
  - [Note](#note)
    - [About SIMD](#about-simd)
    - [Quick guide on SIMD](#quick-guide-on-simd)

## Quick start

### How to pull

**Pull the image by:**

- **`apptainer pull oras://docker.io/zhaoshh/mace:<tag><aux>`**
- **`<tag>` can be one of the followings: `mpich`, `openmpi`, and `tianhe2`.**
- **`<aux>` can be nothing or `-slim` (do not contain G4 data, smaller in size, but you need to install Geant4 data in your machine and setup environment variables).**

For example, `apptainer pull oras://docker.io/zhaoshh/mace:mpich` pulls down an image that MPI library is MPICH, `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2-slim` pulls down an image specialized for Tianhe-2 and does not contain Geant4 data.

**You should choose the correct MPI tag that compatible with MPI that installed in your machine, in order to run do correct parallel computing.** 

If you are going to run the image on Tianhe-2 supercomputer, here is a specialization:

- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2`

or with `-slim`, up to your purpose.

### How to run

The image contains MACE and its dependencies (including ROOT and Geant4 libraries).
You can run MACE simulation by `apptainer run`:

- `apptainer run rgb.sif SimMACE`
- `apptainer run rgb.sif SimTarget`
- `apptainer run rgb.sif SimEMC`

and it should show the program interface.
This image is built based on [RGB](https://hub.docker.com/r/zhaoshh/rgb), so **single-threaded** ROOT and Geant4 are also contained in this image, check them by

- `apptainer run rgb.sif root` (or `apptainer run rgb.sif root.exe` for Tianhe-2 version)
- `apptainer run rgb.sif geant4-config --version`

Common build tools like GCC, CMake, and Ninja are also provided:

- `apptainer run rgb.sif g++ --version`
- `apptainer run rgb.sif cmake --version`
- `apptainer run rgb.sif ninja --version`

Other usage should be the same as [RGB](https://hub.docker.com/r/zhaoshh/rgb).

## Pull command list

- `apptainer pull oras://docker.io/zhaoshh/mace:mpich`
- `apptainer pull oras://docker.io/zhaoshh/mace:mpich-slim`
- `apptainer pull oras://docker.io/zhaoshh/mace:openmpi`
- `apptainer pull oras://docker.io/zhaoshh/mace:openmpi-slim`
- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2`
- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2-slim`

## Note

### About SIMD

SIMD support is automatically enable at runtime, by detecting the host CPU micro-architecture. Supported SIMD instruction sets includes AVX2 and FMA (implementation installed in /opt/avx2), AVX (implementation installed in /opt/avx) and SSE3 (implementation installed in /opt/sse3).
It will automatically choose the most advanced SIMD instruction set available on your machine. SSE3 should be available on almost all machines.

For Tianhe-2 specialization the adaptive SIMD is not enabled and only one implementation compiled with `-march=ivybridge` is contained in the container.

### Quick guide on SIMD

- **AVX2 and FMA** should be available on **x86-64 CPUs after 2015**: Intel CPU posterior to "Haswell" (posterior to Core i7-4XXX, Xeon E5-XXXX v3, etc.), AMD CPU posterior to "Bulldozer Gen4 (Excavator)". Compiled with `-mavx2 -mfma`.
- **AVX** should be available on **x86-64 CPUs after 2013**: Intel CPU posterior to "Sandy Bridge" (posterior to Core i7-2XXX, Xeon E5-XXXX, etc.), AMD CPU posterior to "Bulldozer Gen1". Compiled with `-mavx`.
- **SSE3** should be available on **x86-64 CPUs after 2006**: Intel CPU posterior to "Prescott" (posterior to Pentium 4, Celeron D etc.), AMD CPU posterior to "Athlon 64". Compiled with `-msse3`.

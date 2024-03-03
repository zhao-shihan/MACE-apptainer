# MACE offline software apptainer container

## Contents

- [MACE offline software apptainer container](#mace-offline-software-apptainer-container)
  - [Contents](#contents)
  - [Quick start](#quick-start)
    - [How to pull](#how-to-pull)
    - [How to run](#how-to-run)
      - [Simple usage](#simple-usage)
      - [Recommended usage](#recommended-usage)
    - [Container contents](#container-contents)
    - [Other usage](#other-usage)
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

**You should choose the correct MPI tag that compatible with MPI that installed in your machine, in order to do parallel computation correctly.** 

If you are going to run the image on Tianhe-2 supercomputer, here is a specialization:

- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2`

or with `-slim`, up to your purpose.

### How to run

#### Simple usage

The container contains MACE offline software and its dependencies (including ROOT and Geant4 libraries).
You can run MACE simulation by

- `apptainer run mace.sif SimMACE`
- `apptainer run mace.sif SimTarget`
- `apptainer run mace.sif SimEMC`

Or, after executed `chmod +x mace.sif`, simply

- `./mace.sif SimMACE`
- `./mace.sif SimTarget`
- `./mace.sif SimEMC`

and it should show the program interface.

#### Recommended usage

However, in some cases you may want to use the container from everywhere on you machine.
A recommended usage is to make the container executable and add it to `PATH`.

First, make the container executable by

- `chmod +x mace.sif`

Then, copy/move the container to an installation directory (e.g. `path/to/install`), and (optionally) shorten its name (e.g. `mace`) by

- `mv mace.sif path/to/install/mace`

After that, add the following line in e.g. `~/.bashrc`:

- `export PATH=path/to/install:$PATH`

This line adds the container directory into the `PATH`.
After restarted the terminal/session, you can use the container by entering `mace` directly:

- `mace SimMACE`
  
and it should show the program interface.

**In the remaining part, we assume that the container is used in this way, but you can always switch to the form of `apptainer run`.**

### Container contents

The container contains MACE offline software and its dependencies:

- `mace SimMACE`
- `mace SimTarget`
- `mace SimEMC`

This container is built upon [RGB](https://hub.docker.com/r/zhaoshh/rgb), so **single-threaded** ROOT and Geant4 are also contained in this container, check them by

- `mace root` (or `mace root.exe` for Tianhe-2 specialization)
- `mace geant4-config --version`

Common build tools like GCC, CMake, and Ninja are also provided:

- `mace g++ --version`
- `mace cmake --version`
- `mace ninja --version`

### Other usage

Other usage should be essentially the same as [RGB](https://hub.docker.com/r/zhaoshh/rgb).

## Pull command list

- `apptainer pull oras://docker.io/zhaoshh/mace:mpich`
- `apptainer pull oras://docker.io/zhaoshh/mace:mpich-slim`
- `apptainer pull oras://docker.io/zhaoshh/mace:openmpi`
- `apptainer pull oras://docker.io/zhaoshh/mace:openmpi-slim`
- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2`
- `apptainer pull oras://docker.io/zhaoshh/mace:tianhe2-slim`

## Note

### About SIMD

SIMD support is enabled and auto-detected at runtime, by probing the host CPU micro-architecture. Supported SIMD instruction sets includes AVX2+FMA (binaries in /opt/avx2) and AVX (binaries in /opt/avx).
It will automatically choose the most advanced SIMD instruction set available on your machine. AVX should be available on almost all amd64 machines, except for those ancient relics.

For Tianhe-2 specialization the adaptive SIMD is not enabled and only one implementation compiled with `-march=ivybridge` is contained in the container.

### Quick guide on SIMD

- **AVX2 and FMA** should be available on **x86-64 CPUs after 2015**: Intel CPU posterior to "Haswell" (posterior to Core i7-4XXX, Xeon E5-XXXX v3, etc.), AMD CPU posterior to "Bulldozer Gen4 (Excavator)". Compiled with `-mavx2 -mfma`.
- **AVX** should be available on **x86-64 CPUs after 2013**: Intel CPU posterior to "Sandy Bridge" (posterior to Core i7-2XXX, Xeon E5-XXXX, etc.), AMD CPU posterior to "Bulldozer Gen1". Compiled with `-mavx`.

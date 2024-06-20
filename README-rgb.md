# RGB (*R*OOT and *G*eant4 *b*asic apptainer container)

## Contents

- [RGB (*R*OOT and *G*eant4 *b*asic apptainer container)](#rgb-root-and-geant4-basic-apptainer-container)
  - [Contents](#contents)
  - [Quick start](#quick-start)
    - [How to pull](#how-to-pull)
    - [How to run](#how-to-run)
      - [Simple usage](#simple-usage)
      - [Recommended usage](#recommended-usage)
    - [Container contents](#container-contents)
    - [Build your own container](#build-your-own-container)
    - [Build and run your own apps](#build-and-run-your-own-apps)
  - [Pull command list](#pull-command-list)
  - [Notice](#notice)
    - [About SIMD](#about-simd)

## Quick start

### How to pull

**Pull the image by:**

- **`apptainer pull oras://ghcr.io/zhao-shihan/rgb:<tag><aux>`**
- **`<tag>` can be one of the followings: `mpich`, `openmpi`, and `tianhe2`.**
- **`<aux>` can be nothing or `-mt` (for multi-threaded G4 and ROOT) or `-slim` (do not contain G4 data, smaller in size, but you need to install Geant4 data in your machine and setup environment variables) or `-mt-slim` (combines the two).**

For example, `apptainer pull oras://ghcr.io/zhao-shihan/rgb:mpich-mt` pulls down an container that MPI library is MPICH, and G4 and ROOT are multi-threading enabled, `apptainer pull oras://ghcr.io/zhao-shihan/rgb:tianhe2-slim` pulls down an container specialized for Tianhe-2 and contains single-threaded G4 and ROOT (parallel computing is support by MPI).

**You should choose the correct MPI tag that compatible with MPI that installed in your machine, in order to do parallel computation correctly.** 

If you don't care about MPI and just want a multi-purpose container , then

- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:mpich-mt`

should be good enough.

If you are going to run the container on Tianhe-2 supercomputer, here is a specialization:

- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:tianhe2`

or with `-mt` or `-slim` or `-mt-slim`, up to your purpose.

Available pull commands are listed in the following section.

### How to run

#### Simple usage

The container contains ROOT and Geant4 libraries, you can use applications (r.g. `root`) directly by

- `apptainer run rgb.sif root` (or `apptainer run rgb.sif root` for Tianhe-2 specialization), or simply
- `./rgb.sif root`, after executed `chmod +x rgb.sif`

and it should show the ROOT interface. 

#### Recommended usage

However, in some cases you may want to use the container from everywhere on you machine.
A recommended usage is to make the container executable and add it to `PATH`.

First, make the container executable by

- `chmod +x rgb.sif`

Then, copy/move the container to an installation directory (e.g. `path/to/install`), and (optionally) shorten its name (e.g. `rgb`) by

- `mv rgb.sif path/to/install/rgb`

After that, add the following line in e.g. `~/.bashrc`:

- `export PATH=path/to/install:$PATH`

This line adds the RGB container directory into the `PATH`.
After restarted the terminal/session, you can use the container by entering `rgb` directly:

- `rgb root` (or `rgb root.exe` for Tianhe-2 specialization)
  
and it should show the ROOT interface.

**In the remaining part, we assume that the container is used in this way, but you can always switch to the form of `apptainer run`.**

### Container contents

ROOT utilities are available, for example

- `rgb root` (`root.exe` for Tianhe-2 specialization)
- `rgb hadd`
- `rgb rootcling`

You can also check the Geant4 version or complie flags:

- `rgb geant4-config --version`
- `rgb geant4-config --cflags`

RGB is a basic library container, and it can be used to compile programs depending on ROOT and/or Geant4.
So it provides common build tools like GCC, CMake, and Ninja:

- `rgb g++ --version`
- `rgb cmake --version`
- `rgb ninja --version`

There are many other packages pre-installed in the container.
Except for ROOT and Geant4, you can check all APT-installed packages:

- `rgb apt list`

or list something specific:

- `rgb apt list libgsl-dev`

### Build your own container

You can also write your own [apptainer definition file](https://apptainer.org/docs/user/latest/definition_files.html) and build your own container based on RGB.
This makes use of ROOT and Geant4 installed in RGB, and saves time from compiling them.
Check [https://apptainer.org/docs/user/latest/build_a_container.html]() for more.

### Build and run your own apps

You can also compile your favorite applications that depend on ROOT/Geant4 with RGB, and run with it:

- Configure: `rgb cmake -G Ninja path/to/src`
- Build: `rgb ninja`
- Run: `rgb path/to/your/app`

## Pull command list

- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:mpich`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:mpich-mt`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:mpich-slim`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:mpich-mt-slim`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:openmpi`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:openmpi-mt`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:openmpi-slim`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:openmpi-mt-slim`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:tianhe2`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:tianhe2-mt`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:tianhe2-slim`
- `apptainer pull oras://ghcr.io/zhao-shihan/rgb:tianhe2-mt-slim`

## Notice

### About SIMD

SIMD support is enabled and auto-detected at runtime, by probing the host CPU features. Supported instruction sets includes x86-64-v4 (up to AVX512F, etc., binaries in /opt/x86-64-v4), x86-64-v3 (up to AVX2, AVX, FMA, etc., binaries in /opt/x86-64-v3) and x86-64-v2 (up to SSE4.2, SSSE3, SSE3, etc., binaries in /opt/x86-64-v2).
It will automatically choose the most advanced instruction sets available on your machine. x86-64-v2 should be available on almost all amd64 machines, except for you grandpa's.

For Tianhe-2 specialization the adaptive SIMD is not enabled and only one implementation compiled with `-march=ivybridge` is contained in the container.

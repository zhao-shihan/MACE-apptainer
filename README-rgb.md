# RGB (*R*OOT and *G*eant4 *b*asic apptainer container)

## Contents

- [RGB (*R*OOT and *G*eant4 *b*asic apptainer container)](#rgb-root-and-geant4-basic-apptainer-container)
  - [Contents](#contents)
  - [Quick start](#quick-start)
    - [How to pull](#how-to-pull)
    - [How to use the container](#how-to-use-the-container)
      - [Image content](#image-content)
      - [Build your own container](#build-your-own-container)
      - [Compile and run applications directly](#compile-and-run-applications-directly)
  - [Pull command list](#pull-command-list)
  - [Note](#note)
    - [SIMD](#simd)
    - [Quick guide on SIMD](#quick-guide-on-simd)

## Quick start

### How to pull

**Pull the image by:**

- **`apptainer pull oras://docker.io/zhaoshh/rgb:<tag><aux>`**
- **`<tag>` can be one of the followings: `mpich`, `openmpi`, and `tianhe2`.**
- **`<aux>` can be nothing or `-mt` (for multi-threaded G4 and ROOT) or `-slim` (do not contain G4 data, smaller in size, but you need to install Geant4 data in your machine and setup environment variables) or `-mt-slim`.**

For example, `apptainer pull oras://docker.io/zhaoshh/rgb:mpich-mt` pulls down an container that MPI library is MPICH and G4 and ROOT multi-threading enabled, `apptainer pull oras://docker.io/zhaoshh/rgb:tianhe2-slim` pulls down an container specialized for Tianhe-2 and contains single-threaded G4 and ROOT (parallel computing is support by MPI).

**You should choose the correct MPI tag that compatible with MPI that installed in your machine, in order to do correct parallel computing.** 

If you are going to run the container on Tianhe-2 supercomputer, here is a specialization:

- `apptainer pull oras://docker.io/zhaoshh/rgb:tianhe2`

or with `-mt` or `-slim` or `-mt-slim`, up to your purpose.

### How to use the container

#### Image content

The container contains ROOT and Geant4 libraries, you can use ROOT directly by `apptainer run`:

- `apptainer run rgb.sif root`

and it should show the ROOT interface. Other ROOT utilities are also available, for example

- `apptainer run rgb.sif hadd`
- `apptainer run rgb.sif rootcling`

You can also check the Geant4 version or complie flags:

- `apptainer run rgb.sif geant4-config --version`
- `apptainer run rgb.sif geant4-config --cflags`

RGB is a basic library container, and it can be used to compile programs depending on ROOT and/or Geant4.
So it provides common build tools like GCC, CMake, and Ninja:

- `apptainer run rgb.sif g++ --version`
- `apptainer run rgb.sif cmake --version`
- `apptainer run rgb.sif ninja --version`

There are many other packages pre-installed in the container.
Except for ROOT and Geant4, you can check all APT-installed packages:

- `apptainer run rgb.sif apt list`

or list something specific:

- `apptainer run rgb.sif apt list libgsl-dev`

#### Build your own container

You can also write your own [container definition file](https://apptainer.org/docs/user/latest/definition_files.html) and build your own container based on RGB.
This makes use of ROOT and Geant4 installed in RGB, and saves time from compiling them.
Check [https://apptainer.org/docs/user/latest/build_a_container.html]() for more informations.

#### Compile and run applications directly

Another way you can do is compiling some applications that depends on ROOT/Geant4 with the container, and run in it:

- Configure: `apptainer run rgb.sif cmake -G Ninja path/to/src`
- Build: `apptainer run rgb.sif ninja`
- Run: first run `apptainer shell rgb.sif`, and run the program inside the apptainer shell.

## Pull command list

- `apptainer pull oras://docker.io/zhaoshh/rgb:mpich`
- `apptainer pull oras://docker.io/zhaoshh/rgb:mpich-mt`
- `apptainer pull oras://docker.io/zhaoshh/rgb:mpich-slim`
- `apptainer pull oras://docker.io/zhaoshh/rgb:mpich-mt-slim`
- `apptainer pull oras://docker.io/zhaoshh/rgb:openmpi`
- `apptainer pull oras://docker.io/zhaoshh/rgb:openmpi-mt`
- `apptainer pull oras://docker.io/zhaoshh/rgb:openmpi-slim`
- `apptainer pull oras://docker.io/zhaoshh/rgb:openmpi-mt-slim`
- `apptainer pull oras://docker.io/zhaoshh/rgb:tianhe2`
- `apptainer pull oras://docker.io/zhaoshh/rgb:tianhe2-mt`
- `apptainer pull oras://docker.io/zhaoshh/rgb:tianhe2-slim`
- `apptainer pull oras://docker.io/zhaoshh/rgb:tianhe2-mt-slim`

## Note

### SIMD

SIMD support is automatically enable at runtime, by detecting the host CPU micro-architecture. Supported SIMD instruction sets includes AVX2 and FMA (implementation installed in /opt/avx2), AVX (implementation installed in /opt/avx) and SSE3 (implementation installed in /opt/sse3).
It will automatically choose the most advanced SIMD instruction set available on your machine. SSE3 should be available on almost all machines.

For Tianhe-2 specialization the adaptive SIMD is not enabled and only one implementation compiled with `-march=ivybridge` is contained in the container.

### Quick guide on SIMD

- **AVX2 and FMA** should be available on **x86-64 CPUs after 2015**: Intel CPU posterior to "Haswell" (posterior to Core i7-4XXX, Xeon E5-XXXX v3, etc.), AMD CPU posterior to "Bulldozer Gen4 (Excavator)". Compiled with `-mavx2 -mfma`.
- **AVX** should be available on **x86-64 CPUs after 2013**: Intel CPU posterior to "Sandy Bridge" (posterior to Core i7-2XXX, Xeon E5-XXXX, etc.), AMD CPU posterior to "Bulldozer Gen1". Compiled with `-mavx`.
- **SSE3** should be available on **x86-64 CPUs after 2006**: Intel CPU posterior to "Prescott" (posterior to Pentium 4, Celeron D etc.), AMD CPU posterior to "Athlon 64". Compiled with `-msse3`.

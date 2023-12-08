# RGB (*R*OOT and *G*eant4 *b*asic apptainer image)

## Contents

- [RGB (*R*OOT and *G*eant4 *b*asic apptainer image)](#rgb-root-and-geant4-basic-apptainer-image)
  - [Contents](#contents)
  - [Quick start](#quick-start)
    - [How to pull](#how-to-pull)
    - [How to use the image](#how-to-use-the-image)
      - [Image content](#image-content)
      - [Build your own image](#build-your-own-image)
      - [Compile and run applications directly](#compile-and-run-applications-directly)
  - [Note](#note)
    - [Important note on ISX](#important-note-on-isx)
    - [Quick guide on ISX](#quick-guide-on-isx)
  - [Pull command list](#pull-command-list)

## Quick start

### How to pull

**Pull the image by:**

- **`singularity pull oras://docker.io/zhaoshh/rgb:<isx><aux>`**
- **`<isx>` can be one of the followings: `avx2`, `avx`, `sse3`, and `tianhe2`.**
- **`<aux>` can be nothing or `-mt` (for multi-threaded G4 and ROOT) or `-slim` (do not contain G4 data, smaller in size) or `-mt-slim`.**

For example, `singularity pull oras://docker.io/zhaoshh/rgb:avx2-mt` pulls down an image compiled with avx2 ISX and multi-threaded G4 and ROOT, `singularity pull oras://docker.io/zhaoshh/rgb:tianhe2-slim` pulls down an image specialized for Tianhe-2 and contains multi-threading disabled G4 and ROOT.

If you need a general-purposed image, and have no idea about CPU instruction sets, and you are not using an ancient computer (within 10 years), it is recommended to pull `avx2-mt`:

- `singularity pull oras://docker.io/zhaoshh/rgb:avx2-mt`

If you are going to run the image on Tianhe-2 supercomputer, here is a specialization:

- `singularity pull oras://docker.io/zhaoshh/rgb:tianhe2`

or with `-mt` or `-slim` or `-mt-slim`, up to your purpose.

### How to use the image

#### Image content

The image contains ROOT and Geant4 libraries, you can use ROOT directly by `singularity run`:

- `singularity run rgb.sif root`

and it should show the ROOT interface. other ROOT utilities are also available, for example

- `singularity run rgb.sif hadd`
- `singularity run rgb.sif rootcling`

You can also check the Geant4 version or complie flags:

- `singularity run rgb.sif geant4-config --version`
- `singularity run rgb.sif geant4-config --cflags`

RGB is a basic library image, and it can be used to compile programs depending on ROOT and/or Geant4.
So it provides common build tools like GCC, CMake, and Ninja:

- `singularity run rgb.sif g++ --version`
- `singularity run rgb.sif cmake --version`
- `singularity run rgb.sif ninja --version`

There are many other packages pre-installed in the image.
Except for ROOT and Geant4, you can check all APT-installed packages:

- `singularity run rgb.sif apt list`

or list something specific:

- `singularity run rgb.sif apt list libgsl-dev`

#### Build your own image

You can also write your own [image definition file](https://apptainer.org/docs/user/latest/definition_files.html) and build your own image based on RGB.
This makes use of ROOT and Geant4 installed in RGB, and saves time from compiling them.
Check [https://apptainer.org/docs/user/latest/build_a_container.html]() for more informations.

#### Compile and run applications directly

Another way you can do is compiling some applications that depends on ROOT/Geant4 with the image, and run in it:

- Configure: `singularity run rgb.sif cmake -G Ninja path/to/src`
- Build: `singularity run rgb.sif ninja`
- Run: first run `singularity shell rgb.sif`, and run the program inside the apptainer/singularity shell.

## Note

### Important note on ISX

- **Select `<isx>` to the furthest extent that your CPU architecture supported can maximize performance, but do not use incompatible `<isx>` otherwise it will crash into `SIGILL` (Illegal Instruction)!**

- Use `lscpu` to view instruction sets available on your CPU. Its `Flags:` item will list all available instruction sets.

### Quick guide on ISX

- **`rgb:avx2`** should be compatible to **x86-64 CPUs after 2015**: Intel CPU posterior to "Haswell" (posterior to Core i7-4XXX, Xeon E5-XXXX v3, etc.), AMD CPU posterior to "Bulldozer Gen4 (Excavator)". Compiled with `-mavx2 -mfma`.
- **`rgb:avx`** should be compatible to **x86-64 CPUs after 2013**: Intel CPU posterior to "Sandy Bridge" (posterior to Core i7-2XXX, Xeon E5-XXXX, etc.), AMD CPU posterior to "Bulldozer Gen1". Compiled with `-mavx`.
- **`rgb:sse3`** should be compatible to **x86-64 CPUs after 2006**: Intel CPU posterior to "Prescott" (posterior to Pentium 4, Celeron D etc.), AMD CPU posterior to "Athlon 64". Compiled with `-msse3`.
- **`rgb:tianhe2`** is specialized for Intel "Ivy Bridge" architecture (used by **Tianhe-2 supercomputer**), and its content is specialized for its typical usage. Compiled with `-march=ivybridge`.

## Pull command list

- `singularity pull oras://docker.io/zhaoshh/rgb:avx2`
- `singularity pull oras://docker.io/zhaoshh/rgb:avx2-mt`
- `singularity pull oras://docker.io/zhaoshh/rgb:avx2-slim`
- `singularity pull oras://docker.io/zhaoshh/rgb:avx2-mt-slim`
- `singularity pull oras://docker.io/zhaoshh/rgb:avx`
- `singularity pull oras://docker.io/zhaoshh/rgb:avx-mt`
- `singularity pull oras://docker.io/zhaoshh/rgb:avx-slim`
- `singularity pull oras://docker.io/zhaoshh/rgb:avx-mt-slim`
- `singularity pull oras://docker.io/zhaoshh/rgb:sse3`
- `singularity pull oras://docker.io/zhaoshh/rgb:sse3-mt`
- `singularity pull oras://docker.io/zhaoshh/rgb:sse3-slim`
- `singularity pull oras://docker.io/zhaoshh/rgb:sse3-mt-slim`
- `singularity pull oras://docker.io/zhaoshh/rgb:tianhe2`
- `singularity pull oras://docker.io/zhaoshh/rgb:tianhe2-mt`
- `singularity pull oras://docker.io/zhaoshh/rgb:tianhe2-slim`
- `singularity pull oras://docker.io/zhaoshh/rgb:tianhe2-mt-slim`

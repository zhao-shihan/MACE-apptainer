# isx=(avx512vl avx512f avx2 avx sse3)
# flag0=(-mavx512vl -mavx512f -mavx2 -mavx -msse3)
# flag1=('' '' -mfma '' '')
# flag2=('' '' '' '' '')
isx=(avx2 avx sse3)
flag0=(-mavx2 -mavx -msse3)
flag1=(-mfma '' '')
flag2=('' '' '')

if ((${#isx[@]} != ${#flag0[@]})) || ((${#isx[@]} != ${#flag1[@]})) || ((${#isx[@]} != ${#flag2[@]})); then
    echo 'Size mismatch'
    exit 1
fi

apptainer build \
    rgb-base.sif \
    def/rgb-base.def
apptainer build \
    rgb-mpich-base.sif \
    def/rgb-mpich-base.def &
apptainer build \
    rgb-openmpi-base.sif \
    def/rgb-openmpi-base.def &
wait

apptainer build \
    rgb-tianhe2.sif \
    def/rgb-tianhe2.def
apptainer build \
    --build-arg RGB=rgb-tianhe2.sif \
    rgb-tianhe2-slim.sif def/rgb-slim.def &
apptainer build \
    rgb-tianhe2-mt.sif \
    def/rgb-tianhe2-mt.def
apptainer build \
    --build-arg RGB=rgb-tianhe2-mt.sif \
    rgb-tianhe2-mt-slim.sif def/rgb-slim.def &
for ((i = 0; i < ${#isx[@]}; ++i)); do
    for mpi in mpich openmpi; do
        apptainer build \
            --build-arg BASE=rgb-$mpi-base.sif \
            --build-arg FLAG0=${flag0[$i]} \
            --build-arg FLAG1=${flag1[$i]} \
            --build-arg FLAG2=${flag2[$i]} \
            rgb-${isx[$i]}-$mpi.sif \
            def/rgb.def
        apptainer build \
            --build-arg RGB=rgb-${isx[$i]}-$mpi.sif \
            rgb-${isx[$i]}-$mpi-slim.sif \
            def/rgb-slim.def &
        apptainer build \
            --build-arg BASE=rgb-$mpi-base.sif \
            --build-arg FLAG0=${flag0[$i]} \
            --build-arg FLAG1=${flag1[$i]} \
            --build-arg FLAG2=${flag2[$i]} \
            rgb-${isx[$i]}-$mpi-mt.sif \
            def/rgb-mt.def
        apptainer build \
            --build-arg RGB=rgb-${isx[$i]}-$mpi-mt.sif \
            rgb-${isx[$i]}-$mpi-mt-slim.sif \
            def/rgb-slim.def &
    done
done
wait

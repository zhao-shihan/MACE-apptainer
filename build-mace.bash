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

cd MACE
MACE_COMMIT=$(git rev-parse HEAD)
MACE_TIME=$(git show --pretty=format:'%cI' | head -1)
cd ..

apptainer build \
    --build-arg RGB=rgb-tianhe2.sif \
    --build-arg MACE_SRC="$(pwd)/MACE" \
    --build-arg MACE_COMMIT=$MACE_COMMIT \
    --build-arg MACE_TIME=$MACE_TIME \
    mace-tianhe2.sif \
    def/mace-tianhe2.def &
apptainer build \
    --build-arg RGB=rgb-tianhe2-slim.sif \
    --build-arg MACE_SRC="$(pwd)/MACE" \
    --build-arg MACE_COMMIT=$MACE_COMMIT \
    --build-arg MACE_TIME=$MACE_TIME \
    mace-tianhe2-slim.sif \
    def/mace-tianhe2.def &
wait
for ((i = 0; i < ${#isx[@]}; ++i)); do
    for mpi in mpich openmpi; do
        apptainer build \
            --build-arg RGB=rgb-${isx[$i]}-$mpi.sif \
            --build-arg MACE_SRC="$(pwd)/MACE" \
            --build-arg MACE_COMMIT=$MACE_COMMIT \
            --build-arg MACE_TIME=$MACE_TIME \
            --build-arg FLAG0=${flag0[$i]} \
            --build-arg FLAG1=${flag1[$i]} \
            --build-arg FLAG2=${flag2[$i]} \
            mace-${isx[$i]}-$mpi.sif \
            def/mace.def &
        apptainer build \
            --build-arg RGB=rgb-${isx[$i]}-$mpi-slim.sif \
            --build-arg MACE_SRC="$(pwd)/MACE" \
            --build-arg MACE_COMMIT=$MACE_COMMIT \
            --build-arg MACE_TIME=$MACE_TIME \
            --build-arg FLAG0=${flag0[$i]} \
            --build-arg FLAG1=${flag1[$i]} \
            --build-arg FLAG2=${flag2[$i]} \
            mace-${isx[$i]}-$mpi-slim.sif \
            def/mace.def &
    done
    wait
done

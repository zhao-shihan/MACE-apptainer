cd MACE
MACE_COMMIT=$(git rev-parse HEAD)
MACE_TIME=$(git show --pretty=format:'%cI' | head -1)
cd ..

build_mace() {
    apptainer build \
        --build-arg MUSTARD="$(pwd)/../RGB/rgb-$1.sif" \
        --build-arg MACE_SRC_HOST_DIR="$(pwd)/MACE" \
        --build-arg MACE_COMMIT=$MUSTARD_COMMIT \
        --build-arg MACE_TIME=$MUSTARD_TIME \
        mace-$1.sif \
        def/$2 &&
        apptainer build \
            --build-arg FROM=mace-$1.sif \
            mace-$1-slim.sif \
            def/slim.def
}

build_mace tianhe2 mace-tianhe2.def &
for mpi in mpich openmpi; do
    build_mace $mpi mace.def &
done
wait

cd MACE
MACE_COMMIT=$(git rev-parse HEAD)
MACE_TIME=$(git show --pretty=format:'%cI' | head -1)
cd ..

apptainer build \
    --build-arg MACE_SRC_HOST_DIR="$(pwd)/MACE" \
    --build-arg MACE_COMMIT=$MACE_COMMIT \
    --build-arg MACE_TIME=$MACE_TIME \
    mace-tianhe2.sif \
    def/mace-tianhe2.def &&
    apptainer build \
        --build-arg FROM=mace-tianhe2.sif \
        mace-tianhe2-slim.sif \
        def/slim.def &
for mpi in mpich openmpi; do
    apptainer build \
        --build-arg RGB=rgb-$mpi.sif \
        --build-arg MACE_SRC_HOST_DIR="$(pwd)/MACE" \
        --build-arg MACE_COMMIT=$MACE_COMMIT \
        --build-arg MACE_TIME=$MACE_TIME \
        mace-$mpi.sif \
        def/mace.def &&
        apptainer build \
            --build-arg FROM=mace-$mpi.sif \
            mace-$mpi-slim.sif \
            def/slim.def &
done
wait

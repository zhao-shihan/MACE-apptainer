apptainer build \
    --build-arg G4DATA_ARCHIVE_HOST_DIR="$(pwd)/g4data" \
    rgb-base.sif \
    def/rgb-base.def
apptainer build \
    rgb-tianhe2-base.sif \
    def/rgb-tianhe2-base.def &
apptainer build \
    rgb-mpich-base.sif \
    def/rgb-mpich-base.def &
apptainer build \
    rgb-openmpi-base.sif \
    def/rgb-openmpi-base.def &
wait

apptainer build \
    rgb-tianhe2.sif \
    def/rgb-tianhe2.def &&
    apptainer build \
        --build-arg FROM=rgb-tianhe2.sif \
        rgb-tianhe2-slim.sif def/slim.def &
apptainer build \
    rgb-tianhe2-mt.sif \
    def/rgb-tianhe2-mt.def &&
    apptainer build \
        --build-arg FROM=rgb-tianhe2-mt.sif \
        rgb-tianhe2-mt-slim.sif def/slim.def &
wait
for mpi in mpich openmpi; do
    apptainer build \
        --build-arg BASE=rgb-$mpi-base.sif \
        rgb-$mpi.sif \
        def/rgb.def &&
        apptainer build \
            --build-arg FROM=rgb-$mpi.sif \
            rgb-$mpi-slim.sif \
            def/slim.def &
    apptainer build \
        --build-arg BASE=rgb-$mpi-base.sif \
        rgb-$mpi-mt.sif \
        def/rgb-mt.def &&
        apptainer build \
            --build-arg FROM=rgb-$mpi-mt.sif \
            rgb-$mpi-mt-slim.sif \
            def/slim.def &
    wait
done

apptainer sign rgb-tianhe2.sif
apptainer sign rgb-tianhe2-mt.sif
apptainer sign rgb-tianhe2-slim.sif
apptainer sign rgb-tianhe2-mt-slim.sif
for mpi in mpich openmpi; do
    apptainer sign rgb-$mpi.sif
    apptainer sign rgb-$mpi-mt.sif
    apptainer sign rgb-$mpi-slim.sif
    apptainer sign rgb-$mpi-mt-slim.sif
done

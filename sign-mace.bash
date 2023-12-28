apptainer sign mace-tianhe2.sif
apptainer sign mace-tianhe2-slim.sif
for mpi in mpich openmpi; do
    apptainer sign mace-$mpi.sif
    apptainer sign mace-$mpi-slim.sif
done

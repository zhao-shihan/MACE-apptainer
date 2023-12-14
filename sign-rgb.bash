# isx=(avx512vl avx512f avx2 avx sse3)
isx=(avx2 avx sse3)

apptainer sign rgb-tianhe2.sif
apptainer sign rgb-tianhe2-mt.sif
apptainer sign rgb-tianhe2-slim.sif
apptainer sign rgb-tianhe2-mt-slim.sif
for i in ${isx[@]}; do
    for mpi in mpich openmpi; do
        apptainer sign rgb-$i-$mpi.sif
        apptainer sign rgb-$i-$mpi-mt.sif
        apptainer sign rgb-$i-$mpi-slim.sif
        apptainer sign rgb-$i-$mpi-mt-slim.sif
    done
done

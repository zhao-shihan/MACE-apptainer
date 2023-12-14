# isx=(avx512vl avx512f avx2 avx sse3)
isx=(avx2 avx sse3)

apptainer sign mace-tianhe2.sif
apptainer sign mace-tianhe2-slim.sif
for i in ${isx[@]}; do
    for mpi in mpich openmpi; do
        apptainer sign mace-$i-$mpi.sif
        apptainer sign mace-$i-$mpi-slim.sif
    done
done

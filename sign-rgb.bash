# isx=(tianhe2 avx512vl avx512f avx2 avx sse3)
isx=(tianhe2 avx2 avx sse3)

for i in ${isx[@]}; do
    apptainer sign rgb-$i-mt.sif
    apptainer sign rgb-$i.sif
    apptainer sign rgb-$i-mt-slim.sif
    apptainer sign rgb-$i-slim.sif
done

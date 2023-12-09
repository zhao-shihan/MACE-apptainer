# isx=(tianhe2 avx512vl avx512f avx2 avx sse3)
isx=(tianhe2 avx2 avx sse3)

for i in ${isx[@]}; do
    apptainer sign mace-$i.sif
    apptainer sign mace-$i-slim.sif
done

# tags=(tianhe2 avx512vl avx512f avx2 avx sse3)
tags=(tianhe2 avx2 avx sse3)

for tag in ${tags[@]}; do
    apptainer sign rgb-$tag-mt.sif
    apptainer sign rgb-$tag.sif
    apptainer sign rgb-$tag-mt-slim.sif
    apptainer sign rgb-$tag-slim.sif
done

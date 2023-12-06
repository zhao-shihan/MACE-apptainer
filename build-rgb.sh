# for simd in sse4.2 avx avx2 fma avx512f avx512ifma; do
for simd in sse4.2 avx avx2 fma; do
    apptainer build --build-arg SIMD=${simd} rgb-${simd}.sif rgb.def
done

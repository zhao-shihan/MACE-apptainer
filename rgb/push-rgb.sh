# simd_list=(sse4.2 avx avx2 fma avx512f avx512vl)
simd_list=(sse4.2 avx avx2 fma)

for simd in $simd_list; do
    apptainer sign rgb-$simd.sif
done

apptainer remote login --username $1 oras://docker.io
for simd in $simd_list; do
    apptainer push rgb-$simd.sif oras://docker.io/zhaoshh/rgb:$simd &
done
wait
apptainer remote logout oras://docker.io

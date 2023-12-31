# isx=(avx512vl avx512f avx2 avx sse3)
# flag0=(-mavx512vl -mavx512f -mavx2 -mavx -msse3)
# flag1=('' '' -mfma '' '')
# flag2=('' '' '' '' '')
isx=(avx2 avx sse3)
flag0=(-mavx2 -mavx -msse3)
flag1=(-mfma '' '')
flag2=('' '' '')

if ((${#isx[@]} != ${#flag0[@]})) || ((${#isx[@]} != ${#flag1[@]})) || ((${#isx[@]} != ${#flag2[@]})); then
    echo 'Size mismatch'
    exit 1
fi

apptainer build rgb-base.sif def/rgb-base.def
apptainer build rgb-tianhe2-mt.sif def/rgb-tianhe2-mt.def
apptainer build rgb-tianhe2.sif def/rgb-tianhe2.def
apptainer build --build-arg LOCALIMAGE=rgb-tianhe2-mt.sif rgb-tianhe2-mt-slim.sif def/rgb-slim.def
apptainer build --build-arg LOCALIMAGE=rgb-tianhe2.sif rgb-tianhe2-slim.sif def/rgb-slim.def
for ((i = 0; i < ${#isx[@]}; ++i)); do
    apptainer build --build-arg FLAG0=${flag0[$i]} --build-arg FLAG1=${flag1[$i]} --build-arg FLAG2=${flag2[$i]} rgb-${isx[$i]}-mt.sif def/rgb-mt.def
    apptainer build --build-arg FLAG0=${flag0[$i]} --build-arg FLAG1=${flag1[$i]} --build-arg FLAG2=${flag2[$i]} rgb-${isx[$i]}.sif def/rgb.def
    apptainer build --build-arg LOCALIMAGE=rgb-${isx[$i]}-mt.sif rgb-${isx[$i]}-mt-slim.sif def/rgb-slim.def
    apptainer build --build-arg LOCALIMAGE=rgb-${isx[$i]}.sif rgb-${isx[$i]}-slim.sif def/rgb-slim.def
done

# tag=(avx512vl avx512f avx2 avx sse3)
# flag0=(-mavx512vl -mavx512f -mavx2 -mavx -msse3)
# flag1=('' '' -mfma '' '')
# flag2=('' '' '' '' '')
tag=(avx2 avx sse3)
flag0=(-mavx2 -mavx -msse3)
flag1=(-mfma '' '')
flag2=('' '' '')

if ((${#tag[@]} != ${#flag0[@]})) || ((${#tag[@]} != ${#flag1[@]})) || ((${#tag[@]} != ${#flag2[@]})); then
    echo 'Size mismatch'
    exit 1
fi

apptainer build rgb-base.sif def/rgb-base.def
apptainer build rgb-tianhe2-mt.sif def/rgb-tianhe2-mt.def
apptainer build rgb-tianhe2.sif def/rgb-tianhe2.def
for ((i = 0; i < ${#tag[@]}; ++i)); do
    apptainer build --build-arg FLAG0=${flag0[$i]} --build-arg FLAG1=${flag1[$i]} --build-arg FLAG2=${flag2[$i]} rgb-${tag[$i]}-mt.sif def/rgb-mt.def
    apptainer build --build-arg FLAG0=${flag0[$i]} --build-arg FLAG1=${flag1[$i]} --build-arg FLAG2=${flag2[$i]} rgb-${tag[$i]}.sif def/rgb.def
    apptainer build --build-arg LOCALIMAGE=rgb-${tag[$i]}-mt.sif rgb-${tag[$i]}-mt-slim.sif def/rgb-slim.def
    apptainer build --build-arg LOCALIMAGE=rgb-${tag[$i]}.sif rgb-${tag[$i]}-slim.sif def/rgb-slim.def
done

# isx=(tianhe2 avx512vl avx512f avx2 avx sse3)
isx=(tianhe2 avx2 avx sse3)

success_or_exit() {
    if eval "$1"; then
        >>/dev/null
    else
        exit 1
    fi
}

success_or_exit "apptainer remote login --username $1 oras://docker.io"

for i in ${isx[@]}; do
    success_or_exit "apptainer verify rgb-$i-mt.sif" &
    success_or_exit "apptainer verify rgb-$i.sif" &
    success_or_exit "apptainer verify rgb-$i-mt-slim.sif" &
    success_or_exit "apptainer verify rgb-$i-slim.sif" &
done
wait

auto_retry() {
    local max_attempts=$1
    local command="$2"
    local wait_time=5

    local attempt=0
    while [ $attempt -lt $max_attempts ]; do
        if eval $command; then
            echo "Command executed successfully."
            break
        else
            attempt=$((attempt + 1))
            echo "Attempt $attempt failed, retrying in $wait_time seconds..."
            sleep $wait_time
        fi
    done
    if [ $attempt -eq $max_attempts ]; then
        echo "Command failed after $max_attempts attempts."
    fi
}

for i in ${isx[@]}; do
    auto_retry 99 "apptainer push rgb-$i-mt.sif oras://docker.io/zhaoshh/rgb:$i-mt" &
    auto_retry 99 "apptainer push rgb-$i.sif oras://docker.io/zhaoshh/rgb:$i" &
    auto_retry 99 "apptainer push rgb-$i-mt-slim.sif oras://docker.io/zhaoshh/rgb:$i-mt-slim" &
    auto_retry 99 "apptainer push rgb-$i-slim.sif oras://docker.io/zhaoshh/rgb:$i-slim" &
done
wait

apptainer remote logout oras://docker.io

# tags=(tianhe2 avx512vl avx512f avx2 avx sse3)
tags=(tianhe2 avx2 avx sse3)

success_or_exit() {
    if eval "$1"; then
        >>/dev/null
    else
        exit 1
    fi
}

for tag in ${tags[@]}; do
    success_or_exit "apptainer verify rgb-$tag-mt.sif"
    success_or_exit "apptainer verify rgb-$tag.sif"
    success_or_exit "apptainer verify rgb-$tag-mt-slim.sif"
    success_or_exit "apptainer verify rgb-$tag-slim.sif"
done

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
            echo "Attempt $attempt failed, retry in $wait_time seconds..."
            sleep $wait_time
        fi
    done
    if [ $attempt -eq $max_attempts ]; then
        echo "Command failed after $max_attempts attempts."
    fi
}

#apptainer remote login --username $1 oras://docker.io
for tag in ${tags[@]}; do
    auto_retry 99 "apptainer push rgb-$tag-mt.sif oras://docker.io/zhaoshh/rgb:$tag-mt" &
    auto_retry 99 "apptainer push rgb-$tag.sif oras://docker.io/zhaoshh/rgb:$tag" &
    auto_retry 99 "apptainer push rgb-$tag-mt-slim.sif oras://docker.io/zhaoshh/rgb:$tag-mt-slim" &
    auto_retry 99 "apptainer push rgb-$tag-slim.sif oras://docker.io/zhaoshh/rgb:$tag-slim" &
done
wait
apptainer remote logout oras://docker.io

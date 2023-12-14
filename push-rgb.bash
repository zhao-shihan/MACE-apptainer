# isx=(avx512vl avx512f avx2 avx sse3)
isx=(avx2 avx sse3)

success_or_exit() {
    if eval "$1"; then
        >>/dev/null
    else
        exit 1
    fi
}

success_or_exit "apptainer remote login --username $1 --password $2 oras://docker.io"

apptainer verify rgb-tianhe2.sif &
apptainer verify rgb-tianhe2-mt.sif &
apptainer verify rgb-tianhe2-slim.sif &
apptainer verify rgb-tianhe2-mt-slim.sif &
for i in ${isx[@]}; do
    for mpi in mpich openmpi; do
        apptainer verify rgb-$i-$mpi.sif &
        apptainer verify rgb-$i-$mpi-mt.sif &
        apptainer verify rgb-$i-$mpi-slim.sif &
        apptainer verify rgb-$i-$mpi-mt-slim.sif &
    done
done
wait

auto_retry() {
    local max_attempts=$1
    local command="$2"
    local wait_time=5

    local attempt=0
    while [ $attempt -lt $max_attempts ]; do
        if eval $command; then
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

auto_retry 99 "apptainer push rgb-tianhe2.sif oras://docker.io/zhaoshh/rgb:tianhe2" &
auto_retry 99 "apptainer push rgb-tianhe2-mt.sif oras://docker.io/zhaoshh/rgb:tianhe2-mt" &
auto_retry 99 "apptainer push rgb-tianhe2-slim.sif oras://docker.io/zhaoshh/rgb:tianhe2-slim" &
auto_retry 99 "apptainer push rgb-tianhe2-mt-slim.sif oras://docker.io/zhaoshh/rgb:tianhe2-mt-slim" &
for i in ${isx[@]}; do
    for mpi in mpich openmpi; do
        auto_retry 99 "apptainer push rgb-$i-$mpi.sif oras://docker.io/zhaoshh/rgb:$i-$mpi" &
        auto_retry 99 "apptainer push rgb-$i-$mpi-mt.sif oras://docker.io/zhaoshh/rgb:$i-$mpi-mt" &
        auto_retry 99 "apptainer push rgb-$i-$mpi-slim.sif oras://docker.io/zhaoshh/rgb:$i-$mpi-slim" &
        auto_retry 99 "apptainer push rgb-$i-$mpi-mt-slim.sif oras://docker.io/zhaoshh/rgb:$i-$mpi-mt-slim" &
    done
done
wait

apptainer remote logout oras://docker.io

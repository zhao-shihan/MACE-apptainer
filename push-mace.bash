success_or_exit() {
    if eval "$1"; then
        >>/dev/null
    else
        exit 1
    fi
}

success_or_exit "apptainer registry login --username $1 --password $2 oras://ghcr.io"

apptainer verify mace-tianhe2.sif &
apptainer verify mace-tianhe2-slim.sif &
for mpi in mpich openmpi; do
    apptainer verify mace-$mpi.sif &
    apptainer verify mace-$mpi-slim.sif &
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

auto_retry 999 "apptainer push mace-tianhe2.sif oras://ghcr.io/zhao-shihan/mace:tianhe2" &
auto_retry 999 "apptainer push mace-tianhe2-slim.sif oras://ghcr.io/zhao-shihan/mace:tianhe2-slim" &
for mpi in mpich openmpi; do
    auto_retry 999 "apptainer push mace-$mpi.sif oras://ghcr.io/zhao-shihan/mace:$mpi" &
    auto_retry 999 "apptainer push mace-$mpi-slim.sif oras://ghcr.io/zhao-shihan/mace:$mpi-slim" &
done
wait
# auto_retry 999 "apptainer push mace-mpich.sif oras://ghcr.io/zhao-shihan/mace:latest"

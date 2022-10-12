#!/bin/bash

DOCKER_NNODES=$1

if [ -z "$DOCKER_NNODES" ];
then
    echo "INFO: Number of slurm nodes not given on commandline to docker image."
    echo "INFO: Defaulting to 3 nodes."
    echo "INFO:"
    echo 'INFO: Usage: docker run --hostname=HOSTNAME  --rm -it TAG NNODES'

    DOCKER_NNODES=3
fi


SLURM_CONF_IN=slurm.conf.in
SLURM_CONF=/etc/slurm/slurm.conf

SLURMCTLD_HOST=${HOSTNAME}
SLURMCTLD_ADDR=127.0.0.1

NODE_HOST=${HOSTNAME}
NODE_ADDR=127.0.0.1
NODE_BASEPORT=6001

NODE_NAMES=$(printf "nd[%05i-%05i]" 1 $DOCKER_NNODES)
NODE_PORTS=$(printf "%i-%i" $NODE_BASEPORT $(($NODE_BASEPORT+$DOCKER_NNODES-1)))

(
    echo "NodeName=$NODE_NAMES NodeHostname=${NODE_HOST} NodeAddr=${NODE_ADDR} Port=$NODE_PORTS CPUs=4 State=UNKNOWN"
    echo "PartitionName=dkr Nodes=ALL Default=YES MaxTime=INFINITE State=UP"
) \
| sed -e "s/SLURMCTLDHOST/${SLURMCTLD_HOST}/" \
      -e "s/SLURMCTLDADDR/${SLURMCTLD_ADDR}/" \
    $SLURM_CONF_IN - \
> $SLURM_CONF

NODE_NAME_LIST=$(scontrol show hostnames $NODE_NAMES)

for n in $NODE_NAME_LIST
do
    echo "$NODE_ADDR       $n" >> /etc/hosts
done

echo
echo "Starting Slurm services..."
echo

service munge start
service munge status
service slurmctld start
service slurmctld status

for n in $NODE_NAME_LIST
do
    slurmd -N $n
done

echo
sinfo
echo
echo

echo "INFO: Run ./run_slurm_examples to build and submit example slurm scripts."
echo
echo

exec bash


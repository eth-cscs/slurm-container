#!/bin/bash

dbus-launch
sudo -u munge munged

. /usr/lib64/mpi/gcc/mpich/bin/mpivars.sh

: "${SLURM_CONF_IN=$SLURM_CONFDIR/slurm.conf.in}"
: "${SLURM_CONF=$SLURM_CONFDIR/slurm.conf}"

# Default number of slurm nodes
: "${SLURM_NUMNODES=3}"

# Default slurm controller
: "${SLURMCTLD_HOST=$HOSTNAME}"
: "${SLURMCTLD_ADDR=127.0.0.1}"

# Default node info
: "${NODE_HOST=$HOSTNAME}"
: "${NODE_ADDR=127.0.0.1}"
: "${NODE_BASEPORT=6001}"

# Default hardware profile
: "${NODE_HW=CPUs=4}"

# Generate node names and associated ports
NODE_NAMES=$(printf "nd[%05i-%05i]" 1 $SLURM_NUMNODES)
NODE_PORTS=$(printf "%i-%i" $NODE_BASEPORT $(($NODE_BASEPORT+$SLURM_NUMNODES-1)))


echo "INFO:"
echo "INFO: Creating $SLURM_CONF with"
echo "INFO: "
column -t <<-EOF
      INFO: SLURMCTLD_HOST=$SLURMCTLD_HOST SLURMCTLD_ADDR=$SLURMCTLD_ADDR
      INFO: NODE_HOST=$NODE_HOST NODE_ADDR=$NODE_ADDR NODE_BASEPORT=$NODE_BASEPORT
      INFO: NODE_HW=$NODE_HW
      INFO: SLURM_NUMNODES=$SLURM_NUMNODES
EOF
echo "INFO: "
echo "INFO: Derived values:"
echo "INFO:"
column -t <<-EOF
      INFO: NODE_NAMES=$NODE_NAMES
      INFO: NODE_PORTS=$NODE_PORTS
EOF
echo "INFO:"
echo "INFO: Override any of the non-derived values by setting the respective environment variable"
echo "INFO: when starting Docker."
echo "INFO:"

export PATH=$SLURM_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$SLURM_ROOT/lib:$LD_LIBRARY_PATH
export MANPATH=$SLURM_ROOT/man:$MANPATH

(
    echo "NodeName=${NODE_NAMES} NodeHostname=${NODE_HOST} NodeAddr=${NODE_ADDR} Port=${NODE_PORTS} State=UNKNOWN ${NODE_HW}"
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

$SLURM_ROOT/sbin/slurmctld

for n in $NODE_NAME_LIST
do
    $SLURM_ROOT/sbin/slurmd -N $n
done

echo
sinfo
echo
echo

exec "$@"

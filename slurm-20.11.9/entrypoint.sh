#!/bin/bash

. /usr/lib64/mpi/gcc/mpich/bin/mpivars.sh

./start-slurm.sh


exec "$@"

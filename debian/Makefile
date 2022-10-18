CXX=g++
SLURM_ROOT=/opt/slurm-${SLURM_VERSION}

plugin:
	${CXX} plugin.cpp --shared -o ${SLURM_ROOT}/lib/plugin.so -I${SLURM_ROOT}/include
	echo "required ${SLURM_ROOT}/lib/plugin.so" > ${SLURM_ROOT}/etc/plugstack.conf

mpiex: mpi_hello.c
	mpicc -o mpi_hello mpi_hello.c

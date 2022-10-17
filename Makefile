TAG=slurm-dkr2
PLATFORM="linux/amd64"
SLURM_NUMNODES=3
SLURM_VERSION=20.11.9
#SLURM_VERSION=21.08.8-2
#SLURM_VERSION=22.05.5

SLURM_ROOT=/opt/slurm-${SLURM_VERSION}

all: Dockerfile
	docker build --progress=tty -t ${TAG} .
	#docker build --no-cache --progress=tty -t ${TAG} .

run: 
	docker run \
		--platform=${PLATFORM} \
		--rm -it \
		-e SLURM_VERSION=${SLURM_VERSION} \
		-e SLURM_NUMNODES=${SLURM_NUMNODES} \
		${TAG} 

		#--entrypoint=bash \

plugin:
	g++ plugin.cpp --shared -o ${SLURM_ROOT}/lib/plugin.so -I${SLURM_ROOT}/include
	echo "required ${SLURM_ROOT}/lib/plugin.so" > ${SLURM_ROOT}/etc/plugstack.conf

mpiex: mpi_hello.c
	mpicc -o mpi_hello mpi_hello.c

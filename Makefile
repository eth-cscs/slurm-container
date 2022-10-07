TAG=slurm-dkr2
PLATFORM="linux/amd64"
HOSTNAME=dkr

all: Dockerfile slurm.conf.in
	sed 's/DOCKER_HOSTNAME/${HOSTNAME}/' slurm.conf.in > slurm.conf
	docker build --progress=tty -t ${TAG} .

run: 
	docker run \
		--hostname=${HOSTNAME} \
		--platform=${PLATFORM} \
		--rm -it \
		${TAG} bash

plugin:
	g++ plugin.cpp --shared -o plugin.so -I/usr/include/slurm
	echo "required /plugin.so" > /etc/slurm/plugstack.conf.d/example.conf

mpiex: mpi_hello.c
	mpicc -o mpi_hello mpi_hello.c

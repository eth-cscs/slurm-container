TAG=slurm-dkr2
PLATFORM="linux/amd64"
HOSTNAME=dkr

all: Dockerfile slurm.conf.in
	docker build --progress=tty -t ${TAG} .

run: 
	docker run \
		--platform=${PLATFORM} \
		--rm -it \
		${TAG} 

		#--hostname=${HOSTNAME} 
plugin:
	g++ plugin.cpp --shared -o plugin.so -I/usr/include/slurm
	echo "required /plugin.so" > /etc/slurm/plugstack.conf.d/example.conf

mpiex: mpi_hello.c
	mpicc -o mpi_hello mpi_hello.c

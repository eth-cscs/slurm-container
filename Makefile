TAG=slurm-dkr2
PLATFORM="linux/amd64"
SLURM_NUMNODES?=3
SLURM_VERSION?=20.11.9
SLURM_VERSION?=21.08.8-2
SLURM_VERSION?=22.05.5

all: 
	@echo "Available targets:"
	@echo
	@echo "	debian	    Build Debian based Docker container"
	@echo "	suse	    Build OpenSUSE based Docker container"
	@echo "	run.debian  Start Debian container using SLURM_VERSION and SLURM_NUMNODES"
	@echo "	run.suse    Start OpenSUSE container using SLURM_VERSION and SLURM_NUMNODES"
	@echo
	@echo "SLURM_VERSION and SLURM_NUMNODES can be specified directly in this Makefile or"
	@echo "through environment variables."
	@echo
	@echo

debian: debian/Dockerfile
	docker build -f debian/Dockerfile --progress=tty -t ${TAG}.debian .

suse: suse/Dockerfile
	docker build -f suse/Dockerfile --progress=tty -t ${TAG}.suse .

run: 
	docker run \
		--platform=${PLATFORM} \
		--rm -it \
		-e SLURM_VERSION=${SLURM_VERSION} \
		-e SLURM_NUMNODES=${SLURM_NUMNODES} \
		${TAG} 

run.debian: 
	docker run \
		--platform=${PLATFORM} \
		--rm -it \
		-e SLURM_VERSION=${SLURM_VERSION} \
		-e SLURM_NUMNODES=${SLURM_NUMNODES} \
		${TAG}.debian

run.suse: 
	docker run \
		--platform=${PLATFORM} \
		--rm -it \
		-e SLURM_VERSION=${SLURM_VERSION} \
		-e SLURM_NUMNODES=${SLURM_NUMNODES} \
		${TAG}.suse

		#--entrypoint=bash \


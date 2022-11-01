PLATFORM="linux/amd64"
SLURM_NUMNODES?=3
SLURM_VERSION?=20.11.9
# SLURM_VERSION?=21.08.8-2
# SLURM_VERSION?=22.05.5
TAG=suse-slurm:${SLURM_VERSION}

all: container

container: suse/Dockerfile
	docker build -f suse/Dockerfile --progress=tty -t ${TAG} .

run:
	docker run \
		--platform=${PLATFORM} \
		--rm -it \
		--privileged \
		-e SLURM_NUMNODES=${SLURM_NUMNODES} \
		${TAG}

PLATFORM="linux/amd64"
SLURM_NUMNODES?=3

all:
	@echo "Usage:"
	@echo
	@echo "make <slurm-version-directory-name>"
	@echo
	@echo "make run TAG=<slurm-version-directory-name> [SLURM_NUMNODES=#]"
	@echo
	@echo "SLURM_NUMNODES can be specified to change the number of slurm nodes running in the"
	@echo "container. Default: 3"
	@echo
	@echo

slurm-*: .PHONY
	docker build $@ --progress=tty -t $@:latest

run:
	ID=`docker run --detach --name ${TAG} --rm -it -e SLURM_NUMNODES=${SLURM_NUMNODES} ${TAG} tail -f`	\
	&& echo $$ID \
	&& docker cp example.job			$$ID:.					\
	&& docker cp mpi_example.job			$$ID:.					\
	&& docker cp mpi_hello.c			$$ID:.					\
	&& docker cp run_slurm_examples			$$ID:. \
	&& docker run -it ${TAG} bash

.PHONY:

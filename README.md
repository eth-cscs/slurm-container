# Slurm Plugin-testing Container
A Docker container for developing and testing slurm plugins.
This image uses slurm compiled with the `--enable-multiple-slurmd` option. This
allows multiple slurm daemons to run on the same host and avoids needing
multiple images for each node.

## Building
Run `make` to build the Docker image. 

## Running
Run `make run` to launch the container. 
The number of virtual slurm nodes to start is given as a commandline parameter to the docker image in the Makefile.
The default is three nodes.

At startup, the `slurm.conf` file is generated with the container hostname and number of requested nodes before starting the slurm controller and node daemons.

Once running, use `./run_slurm_examples` to build and example jobs.

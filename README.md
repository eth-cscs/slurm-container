# Slurm Plugin-testing Container
A Docker container for developing and testing slurm plugins.

## Configuration
For `slurm` to work correctly, the hostname in `slurm.conf` must match that of the container. The hostname can be changed in the `Makefile`.
There are currently three nodes (`nd[1-3]`) configured, which means three daemons will need to be started later.

## Building
Run `make` to build the Docker image. 

## Running
Run `make run` to launch the container and ensure that the hostname is consistent with `slurm.conf`.

Once running, use `. start` to launch the slurm controller `slurmctld` and the node daemons.

FROM --platform=linux/amd64 debian:bullseye
RUN apt-get -y update

RUN    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list \
    && sed -i 'p;s/^deb/deb-src/' /etc/apt/sources.list \
    && apt update

RUN apt-get install -y vim less
RUN apt-get install -y mpich libmpich-dev

RUN apt-get install -y munge
RUN apt-get build-dep -y slurm-wlm

RUN apt-get source slurm-wlm
ARG DEB_BUILD_OPTIONS parallel=8

RUN cd slurm-wlm-* && sed -i 's/ dh_auto_configure -- .*/& --enable-multiple-slurmd/' debian/rules 
RUN cd slurm-wlm-* && sed -i 's/ dh_auto_install.*/& --parallel/' debian/rules 
RUN cd slurm-wlm-* && dpkg-buildpackage -us -uc 
RUN dpkg --force-depends -i *.deb && apt-get install -fy

RUN apt-get remove -y slurm-wlm-emulator

RUN mkdir /var/spool/slurmctld && chown slurm /var/spool/slurmctld && chmod u+rwx /var/spool/slurmctld
RUN mkdir /var/spool/slurmd    && chown slurm /var/spool/slurmd    && chmod u+rwx /var/spool/slurmd

COPY cgroup.conf /etc/slurm
COPY slurmd.service /etc/systemd/system/multi-user.target.wants/

COPY run_slurm_examples Makefile example.job mpi_example.job plugin.cpp mpi_hello.c slurm.conf.in entrypoint.sh .

ENTRYPOINT ./entrypoint.sh

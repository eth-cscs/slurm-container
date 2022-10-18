FROM --platform=linux/amd64 debian:bullseye
RUN apt-get -y update

RUN apt-get install -y      \
    libc6                   \
    munge                   \
    ucf                     \
    adduser                 \
    libcurl4                \
    libipmimonitoring6      \
    libjson-c5              \
    libmunge-dev            \
    libnuma1                \
    librrd8                 \
    libreadline-dev         \
    libnuma-dev             \
    hwloc                   \
    libhwloc-dev            \
    libhdf5-dev             \
    man2html                \
    liblz4-dev              \
    zlib1g-dev              \
    freeipmi                \
    libfreeipmi-dev         \
    libjwt-dev              \
    liblua5.1-0-dev         \
    libmariadb-dev          \
    rrdtool                 \
    libyaml-dev             \
    libhttp-parser-dev      \
    libjwt-dev              \
    libcurl4-gnutls-dev     \
    libdbus-1-dev           \
    libmount-dev



RUN apt-get install -y vim less curl ca-certificates bzip2 

RUN apt-get install -y mpich libmpich-dev
RUN apt-get install -y munge
RUN apt-get install -y make python3

RUN useradd slurm
RUN mkdir -p /var/log/slurm
RUN mkdir -p /var/spool/slurmctld && chown slurm /var/spool/slurmctld && chmod u+rwx /var/spool/slurmctld
RUN mkdir -p /var/spool/slurmd    && chown slurm /var/spool/slurmd    && chmod u+rwx /var/spool/slurmd


COPY install_slurm.sh .


ENV SLURM_VERSION 20.11.9
    RUN  ./install_slurm.sh ${SLURM_VERSION} /opt/slurm-${SLURM_VERSION} --enable-multiple-slurmd
    RUN  mkdir -p /opt/slurm-${SLURM_VERSION}/etc

ENV SLURM_VERSION 21.08.8-2
    RUN  ./install_slurm.sh ${SLURM_VERSION} /opt/slurm-${SLURM_VERSION} --enable-multiple-slurmd
    RUN  mkdir -p /opt/slurm-${SLURM_VERSION}/etc

ENV SLURM_VERSION 22.05.5
    RUN  ./install_slurm.sh ${SLURM_VERSION} /opt/slurm-${SLURM_VERSION} --enable-multiple-slurmd
    RUN  mkdir -p /opt/slurm-${SLURM_VERSION}/etc


ENV SLURM_VERSION 20.11.9
    COPY slurm-${SLURM_VERSION}/cgroup.conf /opt/slurm-${SLURM_VERSION}/etc
    COPY slurm-${SLURM_VERSION}/slurm.conf.in /opt/slurm-${SLURM_VERSION}/etc

ENV SLURM_VERSION 21.08.8-2
    COPY slurm-${SLURM_VERSION}/cgroup.conf /opt/slurm-${SLURM_VERSION}/etc
    COPY slurm-${SLURM_VERSION}/slurm.conf.in /opt/slurm-${SLURM_VERSION}/etc
    
ENV SLURM_VERSION 22.05.5
    COPY slurm-${SLURM_VERSION}/cgroup.conf /opt/slurm-${SLURM_VERSION}/etc
    COPY slurm-${SLURM_VERSION}/slurm.conf.in /opt/slurm-${SLURM_VERSION}/etc

COPY debian/entrypoint.sh .
COPY debian/Makefile .

ENTRYPOINT ./entrypoint.sh

COPY run_slurm_examples example.job mpi_example.job plugin.cpp mpi_hello.c .



FROM --platform=linux/amd64 opensuse/leap:15.3


RUN zypper install -y       \
    munge                   \
    munge-devel             \
    libnuma1                \
    libnuma-devel           \
    librrd8                 \
    readline-devel          \
    hwloc                   \
    hwloc-devel             \
    hdf5                    \
    hdf5-devel              \
    lz4                     \
    liblz4-devel            \
    libz1                   \
    zlib-devel              \
    freeipmi                \
    freeipmi-devel          \
    dbus-1                  \
    dbus-1-devel            \
    make                    \
    gcc                     \
    gcc-c++                 \
    curl                    \
    tar                     \
    bzip2                   \
    python3                 \
    vim                     \
    ca-certificates         \
    less                    \
    mpich                   \
    mpich-devel             \
    sudo

RUN zypper install -y    lua53                   \
    lua53-devel             \
    libmount-devel

RUN useradd -M slurm

RUN mkdir -p /var/log/slurm
RUN mkdir -p /var/spool/slurmctld && chown slurm /var/spool/slurmctld && chmod u+rwx /var/spool/slurmctld
RUN mkdir -p /var/spool/slurmd    && chown slurm /var/spool/slurmd    && chmod u+rwx /var/spool/slurmd


COPY install_slurm.sh .


ENV SLURM_VERSION 20.11.9
RUN  ./install_slurm.sh ${SLURM_VERSION} --enable-multiple-slurmd

ENV SLURM_VERSION 20.11.9
RUN  mkdir -p /usr/local/etc/

ENV SLURM_VERSION 20.11.9
COPY slurm-${SLURM_VERSION}/cgroup.conf /usr/local/etc/
COPY slurm-${SLURM_VERSION}/slurm.conf.in /usr/local/etc/

RUN zypper install -y python3-pip
RUN python3 -m pip install --upgrade pip && python3 -m pip install meson ninja


ARG NOCACHE=2
RUN echo "$NOCACHE"

COPY suse/entrypoint.sh .
COPY suse/Makefile .

ENTRYPOINT ./entrypoint.sh /bin/bash

COPY run_slurm_examples example.job  /

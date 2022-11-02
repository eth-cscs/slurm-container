FROM --platform=linux/amd64 opensuse/leap:15.3
#FROM --platform=linux/arm64v8 opensuse/leap:15.3

ENV SLURM_VERSION   20.11.9
ENV SLURM_ROOT      /opt/slurm-${SLURM_VERSION}


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

RUN zypper install -y       \
    lua53                   \
    lua53-devel             \
    libmount-devel

RUN useradd -M slurm

RUN mkdir -p /var/log/slurm
RUN mkdir -p /var/spool/slurmctld && chown slurm /var/spool/slurmctld && chmod u+rwx /var/spool/slurmctld
RUN mkdir -p /var/spool/slurmd    && chown slurm /var/spool/slurmd    && chmod u+rwx /var/spool/slurmd


COPY install_slurm.sh .

RUN  ./install_slurm.sh ${SLURM_VERSION} ${SLURM_ROOT} --enable-multiple-slurmd

RUN  mkdir -p       ${SLURM_ROOT}/etc
COPY cgroup.conf    ${SLURM_ROOT}/etc
COPY slurm.conf.in  ${SLURM_ROOT}/etc

COPY entrypoint.sh .
ENTRYPOINT ./entrypoint.sh

#COPY run_slurm_examples example.job mpi_example.job plugin.cpp mpi_hello.c .


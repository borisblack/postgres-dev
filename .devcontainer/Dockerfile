FROM ubuntu:22.04

# Update and install
RUN apt-get update -y && apt-get install -y sudo locales vim mc build-essential libicu-dev gdb pkg-config git libreadline-dev zlib1g-dev flex bison

# Set locale for initdb
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
# RUN git config --global core.autocrlf false

# Add users
# RUN useradd -m -d /home/developer -s /bin/bash developer \
#     && echo developer:master | chpasswd \
#     && usermod -a -G sudo developer \
#     && echo developer ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/developer

RUN useradd -m -d /home/postgres -s /bin/bash postgres \
    && echo postgres:postgres | chpasswd \
    && usermod -a -G sudo postgres \
    && echo postgres ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/postgres
RUN echo "select pg_backend_pid();" > /home/postgres/.psqlrc

# Postgres environment setup
RUN mkdir -p /usr/local/pgsql/data \
    && chown postgres /usr/local/pgsql/data

ENV PGDATA=/usr/local/pgsql/data
ENV PATH=/usr/local/pgsql/bin/:$PATH

ENTRYPOINT ["tail", "-f", "/dev/null"]

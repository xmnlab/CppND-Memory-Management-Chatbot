FROM ubuntu:18.04

RUN apt-get -qq update --yes \
    && apt-get -qq install --yes \
        wget \
        software-properties-common \
        build-essential \
        make \
        cmake \
        libgoogle-glog-dev \
        libgoogle-glog0v5 \
        sudo \
        gdb \
        bsdmainutils \
    && apt-key adv --fetch-keys http://repos.codelite.org/CodeLite.asc \
    && apt-add-repository 'deb http://repos.codelite.org/wx3.0.5/ubuntu/ bionic universe' \
    && apt-get -qq install --yes \
        libwxbase3.0-0-unofficial \
        libwxbase3.0-dev \
        libwxgtk3.0-0-unofficial \
        libwxgtk3.0-dev \
        wx3.0-headers \
        wx-common \
        libwxbase3.0-dbg \
        libwxgtk3.0-dbg \
        wx3.0-i18n \
        wx3.0-examples \
        wx3.0-doc \
        mingw-w64 \
    && rm -rf /var/lib/apt/lists/*

RUN export uid=1000 gid=1000 home_dir=/home/developer && \
    mkdir -p ${home_dir} && \
    echo "developer:x:${uid}:${gid}:Developer,,,:${home_dir}:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R ${home_dir}

WORKDIR /home/developer
USER developer
ENV HOME /home/developer

ENTRYPOINT /bin/bash

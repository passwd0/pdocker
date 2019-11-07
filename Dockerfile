FROM phusion/baseimage
LABEL Description='ctf_pwn image'
LABEL maintainer='passwd@mes3hacklab.org'

# configurations
WORKDIR /ctf/
RUN echo "export HOME=/root" >> /root/.bashrc
COPY vimrc 	/root/.vimrc
COPY tmux.conf 	/root/.tmux.conf
COPY zshrc	/root/.zshrc
COPY expl.py	/root/expl.py
RUN touch .history

# pkg
RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    xz-utils \
    g++-multilib \
    gcc \
    psutils \
    ipython \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python-dev \
    python \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    zsh \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    flex \
    pkg-config \
    bison --fix-missing

#cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz && \
    tar -xvzf cmake* && \
    cd cmake* && \
    ./configure && make install && \
    cd .. && rm cmake* -rf

#python3.7
RUN add-apt-repository ppa:deadsnakes/ppa -yu && \
    apt install -y python3.7-dev && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python3.7 get-pip.py && \
    python get-pip.py && \
    rm get-pip.py
RUN git clone https://github.com/integeruser/bowkin.git ~/bowkin && \
    ln -s ~/bowkin/bowkin.py /usr/local/bin/bowkin && \
    ln -s ~/bowkin/bowkin-db.py /usr/local/bin/bowkin-db && \
    cd /root/bowkin && \
    pip3.7 install -r requirements.txt && \
    echo -e 'y\n' | python3.7 bowkin-db.py bootstrap --ubuntu-only

# python2.7
RUN pip2.7 install \
    ropper \
    ropgadget \
    pwntools \
    z3-solver && \
    pip2.7 install --upgrade pwntools
RUN wget https://raw.githubusercontent.com/inaz2/roputils/master/roputils.py && \
    mv roputils.py /usr/lib/python2.7/

# gdb tools
RUN git clone https://github.com/longld/peda.git /root/peda
RUN git clone https://github.com/scwuaptx/Pwngdb.git /root/Pwngdb && \
    cp /root/Pwngdb/.gdbinit  /root/.gdbinit

# seccomp
RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

# radare2
RUN git clone https://github.com/radareorg/radare2.git /root/radare2 && \
    cd /root/radare2 && ./sys/install.sh
RUN r2pm init && r2pm update && r2pm -ci r2ghidra-dec

# virtualenv
RUN virtualenv -p python2.7 /root/envAngr && \
    . /root/envAngr/bin/activate && \
    pip install angr && \
    deactivate
RUN virtualenv -p python3.7 /root/envFrida && \
    . /root/envFrida/bin/activate && \
    pip install frida frida-tools && \
    deactivate

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]


FROM tozd/sgx:ubuntu-xenial AS sgx-paho-tools-image
ARG DEBIAN_FRONTEND=noninteractive
ENV ['DEBIAN_FRONTEND'] = 'noninteractive'
RUN apt-get -yq update && \
    apt-get -yq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade && \
    apt-get -yq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
        git vim sudo build-essential gcc gdb make cmake cmake-gui cmake-curses-gui \
        fakeroot devscripts dh-make lsb-release libssl-dev ssh net-tools doxygen graphviz iputils-ping && \
    mkdir -p /opt/openssl && \
    wget https://www.openssl.org/source/old/1.1.0/openssl-1.1.0l.tar.gz -O /opt/openssl/openssl-1.1.0l.tar.gz && \
    tar xzvf /opt/openssl/openssl-1.1.0l.tar.gz --directory /opt/openssl && \
    export LD_LIBRARY_PATH=/opt/openssl/lib && cd /opt/openssl/openssl-1.1.0l && \
        ./config --prefix=/opt/openssl --openssldir=/opt/openssl/ssl && \
        make && sudo make install && make test && \
    touch /etc/profile.d/openssl.sh && chmod a+x /etc/profile.d/openssl.sh && \
        echo 'source /etc/profile.d/openssl.sh' >> /root/.bashrc && \
        echo '#!/bin/bash' > /etc/profile.d/openssl.sh && \
        echo 'source /opt/intel/sgxsdk/environment' >> /etc/profile.d/openssl.sh && \
        echo 'export LD_LIBRARY_PATH=/opt/openssl/lib:${LD_LIBRARY_PATH}' >> /etc/profile.d/openssl.sh && \
        echo '$*' && \
    mkdir -p /repo && \
    cd /repo && git clone https://github.com/eclipse/paho.mqtt.c.git && \
    cd paho.mqtt.c && make build && sudo make all install



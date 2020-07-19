
FROM tozd/sgx:ubuntu-xenial AS sgx-image

FROM sgx-image AS sgx-tools-image
ARG DEBIAN_FRONTEND=noninteractive
ENV ['DEBIAN_FRONTEND'] = 'noninteractive'
RUN apt-get -yq update && apt-get -yq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
RUN apt-get -yq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install git vim sudo build-essential gcc make cmake cmake-gui cmake-curses-gui fakeroot devscripts dh-make lsb-release libssl-dev doxygen graphviz iputils-ping
RUN mkdir -p /opt/openssl && wget https://www.openssl.org/source/old/1.1.0/openssl-1.1.0l.tar.gz -O /opt/openssl/openssl-1.1.0l.tar.gz
RUN tar xzvf /opt/openssl/openssl-1.1.0l.tar.gz --directory /opt/openssl
RUN export LD_LIBRARY_PATH=/opt/openssl/lib && cd /opt/openssl/openssl-1.1.0l && \
		./config --prefix=/opt/openssl --openssldir=/opt/openssl/ssl && \
		make && sudo make install && make test
RUN touch /etc/profile.d/openssl.sh && chmod a+x /etc/profile.d/openssl.sh && \
	echo 'source /etc/profile.d/openssl.sh' >> /root/.bashrc && \
	echo '#!/bin/bash' > /etc/profile.d/openssl.sh && \
	echo 'source /opt/intel/sgxsdk/environment' >> /etc/profile.d/openssl.sh && \
	echo 'export LD_LIBRARY_PATH=/opt/openssl/lib:${LD_LIBRARY_PATH}' >> /etc/profile.d/openssl.sh && \
	echo '$*'

FROM sgx-tools-image AS sgx-paho-tools-image
RUN mkdir -p /repo
RUN cd /repo && git clone https://github.com/eclipse/paho.mqtt.c.git && cd paho.mqtt.c && make build && make install



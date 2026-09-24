FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
	libmicrohttpd-dev \
	libjansson-dev \
	libssl-dev \
	libsofia-sip-ua-dev \
	libglib2.0-dev \
	libopus-dev \
	libogg-dev \
	libcurl4-openssl-dev \
	liblua5.3-dev \
	libconfig-dev \
	pkg-config \
	git \
	cmake \
	build-essential \
	ca-certificates \
	wget \
	meson \
	ninja-build \
	python3 \
	autoconf \
	automake \
	libtool \
	gettext \
	&& rm -rf /var/lib/apt/lists/*

# Install libnice (for ICE)
WORKDIR /tmp
RUN git clone https://gitlab.freedesktop.org/libnice/libnice.git && \
	cd libnice && \
	git checkout 0.1.21 && \
	meson setup build && \
	ninja -C build && \
	ninja -C build install && \
	ldconfig

# Install libsrtp (for SRTP)
WORKDIR /tmp
RUN wget https://github.com/cisco/libsrtp/archive/v2.5.0.tar.gz && \
	tar xfv v2.5.0.tar.gz && \
	cd libsrtp-2.5.0 && \
	./configure --prefix=/usr --enable-openssl && \
	make shared_library && \
	make install && \
	ldconfig

# Install libwebsockets (for WebSocket transport)
WORKDIR /tmp
RUN git clone https://github.com/warmcat/libwebsockets.git && \
	cd libwebsockets && \
	git checkout v4.3.2 && \
	mkdir build && \
	cd build && \
	cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && \
	make && \
	make install && \
	ldconfig

# Clone and build Janus
WORKDIR /tmp
RUN git clone https://github.com/meetecho/janus-gateway.git && \
	cd janus-gateway && \
	git checkout v1.2.4 && \
	sh autogen.sh && \
	./configure --prefix=/opt/janus \
		--enable-websockets \
		--enable-plugin-videoroom \
		--enable-plugin-videocall \
		--enable-plugin-echotest \
		--disable-post-processing \
		--disable-rabbitmq \
		--disable-mqtt \
		--disable-unix-sockets && \
	make && \
	make install && \
	make configs

# Create directory for certificates
RUN mkdir -p /opt/janus/certs

# Cleanup
RUN apt-get clean && \
	rm -rf /tmp/*

WORKDIR /opt/janus

# Expose ports
# 8088: HTTP API
# 8089: WebSocket
# 8188: Admin/Monitor
# 20000-20200: Janus RTP/RTCP
EXPOSE 8088 8089 8188
EXPOSE 20000-20200/udp

# Start Janus
CMD ["/opt/janus/bin/janus", "--configs-folder=/opt/janus/etc/janus"]

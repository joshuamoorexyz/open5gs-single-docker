FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Dependencies
RUN apt update && \
    apt install -y curl sudo git python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git cmake libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson

# MongoDB
RUN apt install -y gnupg && \
    curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    apt update && \
    apt-get install -yq mongodb-org
    
RUN mkdir -p /data/db
#run mongod /usr/bin/mongod

# Clone repo
RUN git clone https://github.com/open5gs/open5gs

# Build and install
WORKDIR /open5gs
RUN meson build --prefix=/open5gs/install && \
    ninja -C build && \
    ninja -C build install

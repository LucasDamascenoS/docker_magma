#!/bin/bash

# BSD 2-Clause License

# Copyright (c) 2025, Lucas Damasceno

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

echo "Starting PacketRusher setup..."

# Load environment variables
echo "Loading environment variables from .env file..."
source .env

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y build-essential linux-headers-generic make git wget tar linux-modules-extra-$(uname -r)

# Install Go
echo "Installing Go..."
wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz
rm go1.24.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.profile
source $HOME/.profile

# Clone PacketRusher repository
echo "Cloning PacketRusher repository..."
git clone https://github.com/HewlettPackard/PacketRusher
cd PacketRusher
export PACKETRUSHER=$PWD
echo "export PACKETRUSHER=$PWD" >> $HOME/.profile
source $HOME/.profile

# Build free5GC gtp5g kernel module
echo "Building free5GC gtp5g kernel module..."
cd $PACKETRUSHER/lib/gtp5g
make clean && make -j && sudo make install

# Build PacketRusher
echo "Building PacketRusher..."
cd $PACKETRUSHER
go mod download
go build cmd/packetrusher.go
./packetrusher --help

# Edit config.yaml configuration file
echo "Configuring config.yaml..."
cp ../packetrusher/packetrusher.yaml config/config.yml
sed -i 's|MNC|'$MNC'|g' config/config.yml
sed -i 's|MCC|'$MCC'|g' config/config.yml
sed -i 's|TAC_PR|'$TAC_PR'|g' config/config.yml
sed -i 's|UE1_KI|'$UE1_KI'|g' config/config.yml
sed -i 's|UE1_OP|'$UE1_OP'|g' config/config.yml
sed -i 's|UE1_AMF|'$UE1_AMF'|g' config/config.yml
sed -i 's|UE1_MSIN|'$UE1_MSIN'|g' config/config.yml
sed -i 's|NR_GNB_IP|'$NR_GNB_IP'|g' config/config.yml
sed -i 's|AMF_IP|'$AMF_IP'|g' config/config.yml

echo "PacketRusher setup completed successfully."
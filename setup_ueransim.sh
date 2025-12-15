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

echo "Starting UERANSIM setup..."

# Load environment variables
echo "Loading environment variables from .env file..."
source .env

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y make gcc g++ libsctp-dev lksctp-tools iproute2
sudo snap install cmake --classic

# Clone UERANSIM repository
echo "Cloning UERANSIM repository..."
git clone https://github.com/aligungr/UERANSIM
cd UERANSIM
git checkout tags/v3.2.6

# Build UERANSIM
echo "Building UERANSIM..."
make

# Edit magma-gnb.yaml configuration file
echo "Configuring magma-gnb.yaml..."
cp ../ueransim/ueransim-gnb.yaml config/magma-gnb.yaml
sed -i 's|MNC|'$MNC'|g' config/magma-gnb.yaml
sed -i 's|MCC|'$MCC'|g' config/magma-gnb.yaml
sed -i 's|TAC|'$TAC'|g' config/magma-gnb.yaml
sed -i 's|NR_GNB_IP|'$NR_GNB_IP'|g' config/magma-gnb.yaml
sed -i 's|AMF_IP|'$AMF_IP'|g' config/magma-gnb.yaml

# Edit magma-ue.yaml configuration file
echo "Configuring magma-ue.yaml..."
cp ../ueransim/ueransim-ue.yaml config/magma-ue.yaml
sed -i 's|MNC|'$MNC'|g' config/magma-ue.yaml
sed -i 's|MCC|'$MCC'|g' config/magma-ue.yaml
sed -i 's|UE1_KI|'$UE1_KI'|g' config/magma-ue.yaml
sed -i 's|UE1_OP|'$UE1_OP'|g' config/magma-ue.yaml
sed -i 's|UE1_AMF|'$UE1_AMF'|g' config/magma-ue.yaml
sed -i 's|UE1_IMEISV|'$UE1_IMEISV'|g' config/magma-ue.yaml
sed -i 's|UE1_IMEI|'$UE1_IMEI'|g' config/magma-ue.yaml
sed -i 's|UE1_IMSI|'$UE1_IMSI'|g' config/magma-ue.yaml
sed -i 's|NR_GNB_IP|'$NR_GNB_IP'|g' config/magma-ue.yaml

echo "UERANSIM setup completed successfully."
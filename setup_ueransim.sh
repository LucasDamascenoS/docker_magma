#!/bin/bash

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
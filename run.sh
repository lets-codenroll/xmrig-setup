#!/bin/bash

# Define color variables
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m' # No Color

# Update and install dependencies
echo -e "${GREEN}Updating and installing required packages...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

# Ask user if they want to add swap
echo -e "${YELLOW}Do you want to add swap? Enter size in GB (or press Enter to skip):${NC}"
read SWAP_SIZE
if [[ ! -z "$SWAP_SIZE" ]]; then
    echo -e "${GREEN}Creating $SWAP_SIZE GB swap file...${NC}"
    sudo fallocate -l ${SWAP_SIZE}G /swapfile
    sudo dd if=/dev/zero of=/swapfile bs=1M count=$((${SWAP_SIZE} * 1024))
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    echo -e "${GREEN}Swap file of $SWAP_SIZE GB created successfully.${NC}"
else
    echo -e "${RED}Skipping swap creation.${NC}"
fi

# Install XMRig
echo -e "${GREEN}Installing XMRig...${NC}"
git clone https://github.com/xmrig/xmrig.git
cd xmrig
mkdir build
cd build
cmake ..
make -j$(nproc)

# Ask user if they want to create config.json
echo -e "${YELLOW}Do you want to create a config.json file? Enter the number of CPU cores (or press Enter to skip):${NC}"
read CPU_CORES

if [[ ! -z "$CPU_CORES" ]]; then
    echo -e "${YELLOW}Enter the pool address:${NC}"
    read POOL_ADDRESS
    
    echo -e "${YELLOW}Enter your wallet address:${NC}"
    read WALLET_ADDRESS
    
    echo -e "${YELLOW}Enter a worker name:${NC}"
    read WORKER_NAME
    
    CONFIG_JSON="{
  \"api\": {
    \"id\": null,
    \"worker-id\": \"$WORKER_NAME\"
  },
  \"autosave\": true,
  \"background\": false,
  \"colors\": true,
  \"randomx\": {
    \"1gb-pages\": false,
    \"rdmsr\": true,
    \"wrmsr\": true,
    \"numa\": true,
    \"scratchpad_prefetch_mode\": 1
  },
  \"cpu\": {
    \"enabled\": true,
    \"huge-pages\": true,
    \"hw-aes\": null,
    \"priority\": 5,
    \"asm\": true,
    \"max-threads-hint\": 100,
    \"argon2-impl\": \"auto\",
    \"astrobwt-max-size\": 550,
    \"astrobwt-avx2\": false
  },
  \"pools\": [
    {
      \"algo\": null,
      \"coin\": null,
      \"url\": \"$POOL_ADDRESS\",
      \"user\": \"$WALLET_ADDRESS\",
      \"pass\": \"$WORKER_NAME\",
      \"rig-id\": \"local-server-1\",
      \"nicehash\": false,
      \"keepalive\": true,
      \"enabled\": true,
      \"tls\": true,
      \"sni\": false,
      \"tls-fingerprint\": null,
      \"daemon\": false,
      \"socks5\": null,
      \"self-select\": null,
      \"submit-to-origin\": false
    }
  ],
  \"donate-level\": 0,
  \"log-file\": null,
  \"retries\": 5,
  \"retry-pause\": 5,
  \"syslog\": false,
  \"verbose\": 0
}"

    echo -e "$CONFIG_JSON" > config.json
    echo -e "${GREEN}config.json file created successfully.${NC}"
else
    echo -e "${RED}Skipping config.json creation.${NC}"
fi

echo -e "${GREEN}Setup complete!${NC}"

# XMRIG Setup

## Overview
This script automates the installation and setup of **XMRig**, a high-performance cryptocurrency miner. It ensures that all necessary dependencies are installed, offers an option to add a swap file, compiles XMRig from source, and generates a custom `config.json` file based on user input.

## Features
- **Automatic package updates** and required dependency installation.
- **Swap file creation** (optional, user-specified size).
- **XMRig installation** and compilation from source.
- **Interactive configuration setup** for mining, including:
  - CPU core count.
  - Mining pool address.
  - Wallet address.
  - Worker name.
- **Colored prompts** for better user experience.

## Prerequisites
- Ubuntu/Debian-based Linux distribution
- sudo privileges

## Installation & Usage

1. **Download the script:**
   ```bash
   git clone https://github.com/your-repo/XMRIG-Setup.git
   cd XMRIG-Setup
   ```

2. **Give execution permissions:**
   ```bash
   chmod +x run.sh
   ```

3. **Run the script:**
   ```bash
   ./run.sh
   ```
   If you encounter a permission issue, try:
   ```bash
   sudo ./run.sh
   ```

## Swap File Configuration
If you choose to add a swap file, you will be prompted to enter the size in **GB**. The script will create the swap, enable it, and adjust system swappiness.

## XMRig Installation
The script will clone the XMRig repository, build the source, and compile it using `cmake` and `make`. It will utilize all available processing power (`-j$(nproc)`).

## Configuration File Generation
If you choose to create a `config.json` file, you will be prompted for:
- Number of CPU cores.
- Mining pool address.
- Wallet address.
- Worker name.

The script will generate a properly formatted `config.json` file with these details inside the `build` directory of XMRig.

## Example `config.json`
```json
{
  "api": {
    "id": null,
    "worker-id": "your-worker-name"
  },
  "pools": [
    {
      "url": "your-pool-address",
      "user": "your-wallet-address",
      "pass": "your-worker-name",
      "keepalive": true,
      "tls": true
    }
  ]
}
```

## Troubleshooting
- **Permission Denied Error**:
  ```bash
  chmod +x run.sh
  sudo ./run.sh
  ```
- **Compilation Failure**: Ensure you have all dependencies installed and sufficient memory available.

## License
This project is licensed under the MIT License. Feel free to modify and distribute.

## Contribution
Feel free to fork and submit a pull request to enhance the script!


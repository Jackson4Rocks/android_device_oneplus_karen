#!/bin/bash
# Self-hosted runner setup script for LineageOS builds
# Run this on your build machine to prepare it as a GitHub Actions self-hosted runner

set -e

echo "=== LineageOS Build Runner Setup ==="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please don't run this as root. Run as your regular user."
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Detected OS: $PRETTY_NAME"
    if [[ "$ID" != "ubuntu" ]] || [[ "$VERSION_ID" < "22.04" ]]; then
        echo "Warning: Ubuntu 22.04+ is recommended for LineageOS 23.2 builds"
    fi
fi

# Check hardware
echo ""
echo "=== Hardware Check ==="
CPU_CORES=$(nproc)
TOTAL_RAM_GB=$(free -g | awk '/^Mem:/ {print $2}')
DISK_FREE_GB=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

echo "CPU cores: $CPU_CORES"
echo "RAM: ${TOTAL_RAM_GB} GB"
echo "Disk free: ${DISK_FREE_GB} GB"

if [ "$CPU_CORES" -lt 8 ]; then
    echo "⚠️  Warning: Less than 8 CPU cores. Builds will be slow."
fi
if [ "$TOTAL_RAM_GB" -lt 32 ]; then
    echo "⚠️  Warning: Less than 32 GB RAM. Build may fail with OOM."
fi
if [ "$DISK_FREE_GB" -lt 300 ]; then
    echo "⚠️  Warning: Less than 300 GB free disk space. Build will likely fail."
fi

# Install dependencies
echo ""
echo "=== Installing Dependencies ==="
sudo apt-get update -qq
sudo apt-get install -y -qq \
    git-core gnupg flex bison build-essential zip curl zlib1g-dev \
    libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev \
    libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc \
    unzip fontconfig openjdk-21-jdk-headless python3 python3-pip \
    rsync schedtool libssl-dev lzop pngcrush libxml2 libxml2-utils \
    liblz4-tool libprotoc-dev protobuf-compiler brotli android-sdk-libsparse-utils \
    jq 2>&1 | tail -10

# Install repo tool
echo ""
echo "=== Installing repo tool ==="
mkdir -p ~/bin
curl -s https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# Configure git
echo ""
echo "=== Configuring Git ==="
git config --global user.name "GitHub Actions Runner"
git config --global user.email "runner@github-actions.local"
git config --global color.ui true

# Setup ccache directory
echo ""
echo "=== Setting up ccache ==="
CCACHE_DIR="/mnt/ccache"
sudo mkdir -p $CCACHE_DIR
sudo chown $USER:$USER $CCACHE_DIR
ccache -M 100G
echo "ccache configured at $CCACHE_DIR with 100GB limit"

# Create build directory
echo ""
echo "=== Creating build directory ==="
mkdir -p ~/android/lineage

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Register the runner with GitHub:"
echo "   cd ~ && mkdir -p actions-runner && cd actions-runner"
echo "   curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz"
echo "   tar xzf actions-runner-linux-x64-2.316.1.tar.gz"
echo "   ./config.sh --url https://github.com/<YOUR_USER>/<YOUR_REPO> --labels self-hosted,linux,x64,lineageos-build"
echo "   ./run.sh"
echo ""
echo "2. Or run as a service:"
echo "   sudo ./svc.sh install"
echo "   sudo ./svc.sh start"
echo ""
echo "3. Trigger builds from GitHub Actions tab"
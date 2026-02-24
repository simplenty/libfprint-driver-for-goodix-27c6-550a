#!/usr/bin/env bash
set -euo pipefail

# Define Exact Direct Links from your Repo
LINK1="https://github.com/Lakshit-Gupta/libfprint-driver-for-goodix-27c6-550a/releases/download/v1/libfprint-2-tod1_1.94.7+tod1-0ubuntu5.24.04.4_amd64.deb"
LINK2="https://github.com/Lakshit-Gupta/libfprint-driver-for-goodix-27c6-550a/releases/download/v1/libfprint-2-2_1.94.9+tod1-1_amd64.deb"
LINK3="https://github.com/Lakshit-Gupta/libfprint-driver-for-goodix-27c6-550a/releases/download/v1/libfprint-2-tod-goodix_amd64.deb"


TEMP_DIR="goodix_install_temp"
USER_TO_ENROLL="${SUDO_USER:-$USER}"

echo "-------------------------------------------------------"
echo "Starting Goodix Fingerprint Setup for Debian/Pop!_OS"
echo "-------------------------------------------------------"

echo "[1/5] Updating package lists..."
sudo apt update

echo "[2/5] Fetching driver files from Lakshit-Gupta repository..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Using -L to follow any GitHub redirects
wget -L -O lib1.deb "$LINK1"
wget -L -O lib2.deb "$LINK2"
wget -L -O lib3.deb "$LINK3"

echo "[3/5] Installing specific driver versions via dpkg..."
# Using || true ensures the script keeps moving to the 'apt install -f' fix
sudo dpkg -i lib1.deb || true
sudo dpkg -i lib2.deb || true
sudo dpkg -i lib3.deb || true

echo "Fixing dependencies and installing fprintd..."
sudo apt install -f -y
sudo apt install -y fprintd libpam-fprintd

echo ""
echo "!!! ACTION REQUIRED !!!"
echo "In the next screen:"
echo "- Use SPACE to ensure [*] Fingerprint authentication is enabled."
echo "- TAB to <Ok>, then ENTER."
echo "-------------------------------------------------------"
read -r -p "Press Enter to open PAM configuration... "
sudo pam-auth-update

echo ""
echo "-------------------------------------------------------"
echo "  FINGERPRINT ENROLLMENT"
echo "-------------------------------------------------------"
echo "User: $USER_TO_ENROLL"
echo "Touch your RIGHT INDEX finger (or preferred finger)"
echo "on the sensor repeatedly until enrollment completes."
echo "-------------------------------------------------------"

# Enrolling as the actual user, not root
sudo -u "$USER_TO_ENROLL" fprintd-enroll

echo ""
echo "Verification: touch the sensor again when prompted."
sudo -u "$USER_TO_ENROLL" fprintd-verify

cd ..
rm -rf "$TEMP_DIR"

echo "-------------------------------------------------------"
echo "Setup Complete! Your Goodix 27c6:550a should now work."
echo "-------------------------------------------------------"

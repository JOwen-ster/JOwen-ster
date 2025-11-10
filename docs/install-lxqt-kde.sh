    #!/bin/bash
# --------------------------------------------------------
# Raspberry Pi OS Lite -> LXQt (KDE-style) setup script
# Optimized for Raspberry Pi 3B
# --------------------------------------------------------

set -e

echo ">>> Updating system..."
sudo apt update
sudo apt full-upgrade -y

echo ">>> Installing LXQt desktop and display manager (sddm)..."
sudo apt install -y lxqt sddm

echo ">>> Setting SDDM as default display manager..."
sudo debconf-set-selections <<< "sddm shared/default-x-display-manager select sddm"

echo ">>> Installing KDE Breeze themes and Qt components..."
sudo apt install -y \
    breeze-icon-theme \
    kde-style-breeze \
    qml-module-org-kde-kquickcontrols2 \
    qml-module-org-kde-kirigami2 \
    qt5-style-plugins \
    openbox obconf

echo ">>> Installing performance and quality-of-life tools..."
sudo apt install -y zram-tools lightdm-gtk-greeter-settings lxappearance

echo ">>> Configuring zram swap..."
sudo sed -i 's/# ALGO=lz4/ALGO=lz4/' /etc/default/zramswap || true
sudo systemctl enable zramswap.service

echo ">>> Disabling unneeded background services..."
sudo systemctl disable --now bluetooth.service || true
sudo systemctl disable --now ModemManager.service || true
sudo systemctl disable --now triggerhappy.service || true

echo ">>> Applying LXQt KDE-style appearance..."
mkdir -p ~/.config/lxqt
cat <<EOF > ~/.config/lxqt/session.conf
[General]
window_manager=openbox
icon_theme=breeze
theme=Breeze
EOF

echo ">>> Setting Openbox theme to Breeze (if available)..."
mkdir -p ~/.config/openbox
cat <<EOF > ~/.config/openbox/rc.xml
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config>
  <theme>
    <name>Breeze</name>
    <titleLayout>NLIMC</titleLayout>
  </theme>
</openbox_config>
EOF

echo ">>> All done!"
sudo reboot

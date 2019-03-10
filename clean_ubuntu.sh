#!/bin/bash

if [ ! -z "$XDG_SESSION_TYPE" ]; then
    echo "This script is not supposed to run on desktop! It will damage your system!"
    exit
fi

if [ "$EUID" != "0" ]; then
    echo "Usage: sudo $0"
    exit
fi

echo "Do not install recommended and suggested packages by default..."
cat <<EOF > /etc/apt/apt.conf.d/999aptsettings
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF
echo "Done"

echo "Removing preinstalled bloatware..."
echo apt-get -y purge landscape-client landscape-common resolvconf byobu \
            apport apport-symptoms python3-apport unattended-upgrades \
            snap-confine snapd ubuntu-core-launcher accountsservice \
            libpolkit-agent-1-0 libpolkit-backend-1-0 libpolkit-gobject-1-0 \
            popularity-contest ubuntu-advantage-tools update-notifier-common \
            friendly-recovery pastebinit plymouth plymouth-theme-ubuntu-text \
            os-prober ubuntu-release-upgrader-core update-manager-core
echo "Done"

echo "Disabling motd functionality in pam.d modules..."
sed -i '/^session\s.*optional\s.*pam_motd.so.*/s/^/#/g' /etc/pam.d/sshd
sed -i '/^session\s.*optional\s.*pam_motd.so.*/s/^/#/g' /etc/pam.d/login
echo "Done"

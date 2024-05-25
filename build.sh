#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
#rpm-ostree install @base-x @standard @kde akmod-nvidia code firefox{,-langpacks} flatpak git google-noto-sans-cjk-fonts gwenview htop iwlwifi-mvm-firmware kcalc keepassxc krita libavcodec-freeworld mesa-va-drivers-freeworld mpv neofetch NetworkManager-wifi nmap nvtop okular plymouth-kcm snapper speedtest-cli strace tlp vim virt-viewer xorg-x11-drv-nvidia-cuda

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

#systemctl enable tlp
#systemctl set-default graphical.target

### Disable SystemD targets/services
systemctl disable sshd.service

### Remove unnecessary packages from core OS (mostly for running as or managing containers)
REMOVE_PACKAGES=""
for pkgs in \
NetworkManager-cloud \
NetworkManager-team \
afterburn \
clevis \
cloud \
console \
google \
intel \
moby \
nvidia-container \
sssd \
systemd-container \
teamd \
toolbox; do REMOVE_PACKAGES=$REMOVE_PACKAGES`rpm -qa --qf "%{NAME}\n" | grep -E '^'$pkgs | tr '\n' ' '`; done

# sssd-client causes the build to fail, so removing it from list of packages to remove
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/sssd-client //')

rpm-ostree override remove $REMOVE_PACKAGES

# Policy to allow upgrades when new builds are available
cat << 'EOF' | tee /etc/containers/policy.json
{
    "default": [{"type": "reject"}],
    "transports": {
        "docker": {
            "ghcr.io/nu1bit": [{"type": "insecureAcceptAnything"}]
        }
    }
}
EOF

#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Compile list of unnecessary packages from base image
REMOVE_PACKAGES=""
for pkgs in \
ImageMagick LibRaw ModemManager NetworkManager-{bluetooth,wwan} \
anthy antiword apr atheros avif \
b43 braille brcmfmac brl \
c-ares cirrus \
default-fonts-{other,am,ar,as,be,bg,bn,bo,br,chr,dv,dz,el,eo,eu,fa,gu,he,hi,hy,ia,iu,ka,km,kn,ku} \
default-fonts-{lo,mai,ml,mni,mr,my,nb,ne,nn,nr,nso,or,pa,ru,sat,si,ss,ta,te,th,tn,ts,uk,ur,ve,vi,xh,yi,zu} \
espeak \
fedora-{bookmarks,chromium-config,flathub-remote} flite fpaste fwupd-plugin-modem \
gdouros google-noto-{naskh,sans,serif} gstreamer1-plugins-good-qt \
heif hfsplus hyperv \
ibus-{authy,hangul,libpinyin,libzhuyin,m17n} intel \
jomolhari \
kasumi kyotocabinet \
liblouis libpinyin libva-intel libzhuyin lrzsz \
madan mpage \
nilfs nxpwireless \
open{exr,rgb,sc} orca oversteer \
paktype paps pcsc python3-{boto,brl,louis,pyatspi,s3transfer,simpleaudio,speechd} \
qemu qrencode qt5 \
rit \
sil solaar speech spice sssd \
tiwilink tracker \
vazir virtualbox vmaf; do \
REMOVE_PACKAGES=$REMOVE_PACKAGES`rpm -qa --qf "%{NAME}\n" | grep -E '^'$pkgs | tr '\n' ' '`; done

# Keeping back certain packages as they are core dependancies for other packages
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/ModemManager-glib //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-sans-cjk-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-sans-math-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-sans-mono-cjk-vf-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-sans-mono-vf-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-sans-symbols-vf-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-sans-symbols2-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-sans-vf-fonts//')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-serif-cjk-vf-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/google-noto-serif-vf-fonts //')
REMOVE_PACKAGES=$(echo "$REMOVE_PACKAGES" | sed -r 's/intel-gmmlib //')

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

## Post install (if rebasing from Kinoite)
#flatpak remove -y org.kde.{okular,krdc,kolourpaint,kmines,kmahjongg,kcalc,gwenview,elisa} org.fedoraproject.KDE6Platform

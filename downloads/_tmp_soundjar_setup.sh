#!/bin/sh
# CREATE COPY SCRIPT FOR THOSE FILES (UNSING install COMMAND)
# CREATE SCRIPT TO MODIFY THESE FILES

# DEPENDENCIES (enable bluetooth / install required packages)
    /boot/dietpi/func/dietpi-set_hardware bluetooth enable
    apt install python3-pip bluez-alsa-utils bluez-tools pkgconf libasound2-dev python3-dev g++

# LEDFX
    python3 -m venv root/.ledfx
    /root/.ledfx/bin/python -m pip install --upgrade pip wheel setuptools ledfx
    curl -fsSL "${SJ_URL}/_etc_systemd_system_sj-ledfx.service" | install -m 644 /dev/stdin "/etc/systemd/system/ledfx.service"

# SENDSPIN # REPLACE WITH OWN MODIFIED INSTALL SCRIPT & SERVICE-FILE
    # curl -fsSL https://raw.githubusercontent.com/Sendspin/sendspin-cpp-cli/main/scripts/get_started_linux.sh | bash -s -- --yes
    sed -i "s/#name = kitchen/name = ${SJ_NAME}/"                                   "/etc/sendspin-cli.conf"
    sed -i "s/#manufacturer = sendspin-cpp-cli/manufacturer = \"Raspberry Pi\"/"    "/etc/sendspin-cli.conf"
    sed -i "s/#buffer-ms = 100/buffer-ms = 1000/"                                   "/etc/sendspin-cli.conf"
    sed -i "s/#server = mdns:Living Room/Server = ${SJ_SERVER}/"                    "/etc/sendspin-cli.conf"
    sed -i "s/#pairing-code = 48151623/pairing-code = ${!$SJ_CODE}/"                "/etc/sendspin-cli.conf"

# AUDIO
    curl -fsSL "${SJ_URL}/_etc_modules-load.d_snd-aloop.conf" | install -m 644 /dev/stdin "/etc/modules-load.d/snd-aloop.conf"
    curl -fsSL "${SJ_URL}/_etc_asound.conf"                   | install -m 644 /dev/stdin "/etc/asound.conf"
    sed -i "s/        slaves.dac.pcm \"SJ_SOUNDCARD\"/        slaves.dac.pcm \"${SJ_SOUNDCARD}\"" "/etc/asound.conf"
    
# BLUETOOTH
    curl -fsSL "${SJ_URL}/_etc_systemd_system_bluealsa.service.d_override.conf"         | install -m 644 /dev/stdin "/etc/systemd/system/bluealsa.service.d/override.conf"
    curl -fsSL "${SJ_URL}/_etc_systemd_system_bluealsa-aplay.service.d_override.conf"   | install -m 644 /dev/stdin "/etc/systemd/system/bluealsa-aplay.service.d/override.conf"
    sed -i "s/#DiscoverableTimeout = 0/DiscoverableTimeout = 0/"           "/etc/bluetooth/main.conf"
    sed -i "s/#PairableTimeout = 0/PairableTimeout = 0/"                   "/etc/bluetooth/main.conf"
    sed -i "s/#JustWorksRepairing = never/JustWorksRepairing = always/"    "/etc/bluetooth/main.conf"

# SOUNDJAR
    curl -fsSL "${SJ_URL}/_etc_systemd_system_sj-audio-bluetooth.service"   | install -m 644 /dev/stdin "/etc/systemd/system/sj-audio-bluetooth.service"
    curl -fsSL "${SJ_URL}/_etc_systemd_system_sj-audio-sendspin.service"    | install -m 644 /dev/stdin "/etc/systemd/system/sj-audio-sendspin.service"
    curl -fsSL "${SJ_URL}/_etc_systemd_system_sj-bt-agent.service"          | install -m 644 /dev/stdin "/etc/systemd/system/sj-bt-agent.service"
##########
    #apt remove pkgconf libasound2-dev python3-dev g++
    #apt autoremove
    # options snd-aloop pcm_substreams=1 > etc/modprobe.d/snd-aloop.conf
    #usermod -aG audio dietpi
    #sudo -u dietpi ./downloads/userscript.sh
    # Specs: 96Khz / 32bit / Mono
    #echo "snd-aloop" >> /etc/modules
    #modprobe snd-aloop
    #curl -fsSL https://raw.githubusercontent.com/Sendspin/sendspin-cpp-cli/main/scripts/get_started_linux.sh | bash
    #aplay -l
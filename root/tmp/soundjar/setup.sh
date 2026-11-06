#!/bin/bash
    get_latest_version() {
        curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/${1}/releases/latest" | sed 's|.*/tag/v||'
    }
    download_file() {
        curl -L "${SJ_URL}/${1}" | install -D -m 644 /dev/stdin "${1}"
    }

# INSTALL > DEPENDENCIES
    /boot/dietpi/func/dietpi-set_hardware bluetooth enable

# INSTALL > LEDFX
    python3 -m venv root/.ledfx
    /root/.ledfx/bin/python -m pip install --upgrade pip wheel setuptools ledfx
    #curl -L "${SJ_URL}/_etc_systemd_system_sj-ledfx.service" | install -D -m 644 /dev/stdin "/etc/systemd/system/ledfx.service"

# INSTALL > SENDSPIN
    SJ_SENDSPIN_VERSION=$(get_latest_version "Sendspin/sendspin-cpp-cli")
    curl -Lo "/tmp/sendspin-cpp-cli.tar.gz" "https://github.com/Sendspin/sendspin-cpp-cli/releases/latest/download/sendspin-cli-${SJ_SENDSPIN_VERSION}-linux-arm64.tar.gz"
    tar -xOf "/tmp/sendspin-cpp-cli.tar.gz" --strip-components=4 "sendspin-cli-${SJ_SENDSPIN_VERSION}-linux-arm64/usr/local/bin/sendspin-cli" | \
        install -D -m 755 "/dev/stdin" "/usr/bin/sendspin-cli"
    tar -xOf "/tmp/sendspin-cpp-cli.tar.gz" --strip-components=6 "sendspin-cli-${SJ_SENDSPIN_VERSION}-linux-arm64/usr/local/lib/systemd/system/sendspin-cli.service" | \
        install -D -m 644 "/dev/stdin" "/usr/lib/systemd/system/sendspin-cli.service"
    tar -xOf "/tmp/sendspin-cpp-cli.tar.gz" --strip-components=6 "sendspin-cli-${SJ_SENDSPIN_VERSION}-linux-arm64/usr/local/share/doc/sendspin-cli/sendspin-cli.conf.example" | \
        install -D -m 644 "/dev/stdin" "/etc/sendspin-cli.conf"

# DOWNLOAD FILES > AUDIO
    download_file "/etc/asound.conf"
    download_file "/etc/modules-load.d/snd-aloop.conf"

# DOWNLOAD FILES > OVERRIDES
    download_file "/etc/systemd/system/bluealsa.service.d/override.conf"
    download_file "/etc/systemd/system/bluealsa-aplay.service.d/override.conf"
    download_file "/etc/systemd/system/sendspin-cli.service.d/override.conf"

# DOWNLOAD FILES > SERVICES
    download_file "/etc/systemd/system/sj-audio-bluetooth.service"
    download_file "/etc/systemd/system/sj-audio-sendspin.service"
    download_file "/etc/systemd/system/sj-bt-agent.service"

# CONFIFURE > SENDSPIN
    sed -i "s/#name = kitchen/name = ${SJ_NAME}/"                                   "/etc/sendspin-cli.conf"
    sed -i "s/#manufacturer = sendspin-cpp-cli/manufacturer = \"Raspberry Pi\"/"    "/etc/sendspin-cli.conf"
    sed -i "s/#buffer-ms = 100/buffer-ms = 1000/"                                   "/etc/sendspin-cli.conf"
    sed -i "s/#server = mdns:Living Room/Server = ${SJ_SERVER}/"                    "/etc/sendspin-cli.conf"
    sed -i "s/#pairing-code = 48151623/pairing-code = ${SJ_CODE}/"                  "/etc/sendspin-cli.conf"

# CONFIGURE > AUDIO
    sed -i "s/        slaves.dac.pcm \"SJ_SOUNDCARD\"/        slaves.dac.pcm \"${SJ_SOUNDCARD}\"/" "/etc/asound.conf"
    
# CONFIGURE > BLUETOOTH
    sed -i "s/#DiscoverableTimeout = 0/DiscoverableTimeout = 0/"           "/etc/bluetooth/main.conf"
    sed -i "s/#PairableTimeout = 0/PairableTimeout = 0/"                   "/etc/bluetooth/main.conf"
    sed -i "s/#JustWorksRepairing = never/JustWorksRepairing = always/"    "/etc/bluetooth/main.conf"


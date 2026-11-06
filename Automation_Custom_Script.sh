#!/bin/sh
################ CONFIG ################
SJ_NAME="Soundjar"
SJ_SOUNDCARD="hw:CARD=sndrpihifiberry,DEV=0"
SJ_SERVER="192.168.0.2:8927"
SJ_CODE="12345678"
SJ_GPIO_LED="12"
SJ_GPIO_BUTTON="13"
SJ_URL="https://raw.githubusercontent.com/Switch123456789/Soundjar/main/root"
########################################

mkdir -p /tmp/soundjar; curl -s -o "/tmp/soundjar/setup.sh" "${SJ_URL}/tmp/soundjar/setup.sh";
# shellcheck source=./root/tmp/soundjar/setup.sh
. /tmp/soundjar/setup.sh
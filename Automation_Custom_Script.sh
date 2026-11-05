#!/bin/sh
################ CONFIG ################
SJ_NAME="Soundjar"
SJ_SOUNDCARD="hw:CARD=sndrpihifiberry,DEV=0"
SJ_SERVER="192.168.0.2:8927"
SJ_CODE="12345678"
SJ_GPIO_LED="12"
SJ_GPIO_BUTTON="13"
SJ_URL="https://raw.githubusercontent.com/Switch123456789/Soundjar/main/downloads"
########################################

# shellcheck source=./downloads/_tmp_soundjar_setup.sh
curl -fsSL "${SJ_URL}/_tmp_soundjar_setup.sh" -o "/tmp/soundjar/setup.sh"
. ./tmp/soundjar/setup.sh

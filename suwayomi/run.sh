#!/usr/bin/with-contenv sh
set -eu

DATA_DIR="/data/Tachidesk"
APP_HOME="/home/suwayomi/.local/share"
APP_DATA="${APP_HOME}/Tachidesk"
OPTIONS_FILE="/data/options.json"

mkdir -p "${DATA_DIR}/downloads"
mkdir -p "${APP_HOME}"

if [ -e "${APP_DATA}" ] && [ ! -L "${APP_DATA}" ]; then
  rm -rf "${APP_DATA}"
fi

if [ ! -L "${APP_DATA}" ]; then
  ln -s "${DATA_DIR}" "${APP_DATA}"
fi

TZ_VALUE="Europe/Rome"
if [ -f "${OPTIONS_FILE}" ] && command -v jq >/dev/null 2>&1; then
  TZ_VALUE="$(jq -r '.tz // "Europe/Rome"' "${OPTIONS_FILE}")"
fi
export TZ="${TZ_VALUE}"

export BIND_IP="0.0.0.0"
export BIND_PORT="4567"

if [ -x /home/suwayomi/startup_script.sh ]; then
  exec /home/suwayomi/startup_script.sh
elif command -v startup_script.sh >/dev/null 2>&1; then
  exec startup_script.sh
elif command -v suwayomi-server >/dev/null 2>&1; then
  exec suwayomi-server
else
  echo "Unable to locate Suwayomi startup command"
  exit 1
fi

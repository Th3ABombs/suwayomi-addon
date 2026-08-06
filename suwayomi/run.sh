#!/bin/sh
set -eu

DATA_DIR="/data/Tachidesk"
DOWNLOADS_DIR="/share/suwayomi/downloads"
APP_HOME="/home/suwayomi/.local/share"
APP_DATA="${APP_HOME}/Tachidesk"
APP_DOWNLOADS="${APP_DATA}/downloads"
OPTIONS_FILE="/data/options.json"

mkdir -p "${DATA_DIR}"
mkdir -p "${DOWNLOADS_DIR}"
mkdir -p "${APP_HOME}"

if [ -e "${APP_DATA}" ] && [ ! -L "${APP_DATA}" ]; then
  rm -rf "${APP_DATA}"
fi

if [ ! -L "${APP_DATA}" ]; then
  ln -s "${DATA_DIR}" "${APP_DATA}"
fi

if [ -e "${APP_DOWNLOADS}" ] && [ ! -L "${APP_DOWNLOADS}" ]; then
  rm -rf "${APP_DOWNLOADS}"
fi

if [ ! -L "${APP_DOWNLOADS}" ]; then
  ln -s "${DOWNLOADS_DIR}" "${APP_DOWNLOADS}"
fi

TZ_VALUE="Europe/Rome"
UPDATE_INTERVAL_VALUE="12"
UPDATE_MANGA_INFO_VALUE="false"
UPDATE_EXCLUDE_STARTED_VALUE="false"
UPDATE_EXCLUDE_COMPLETED_VALUE="true"
WEB_UI_UPDATE_INTERVAL_VALUE="0"
AUTO_DOWNLOAD_CHAPTERS_VALUE="true"
AUTO_DOWNLOAD_EXCLUDE_UNREAD_VALUE="true"
AUTO_DOWNLOAD_NEW_CHAPTERS_LIMIT_VALUE="5"
AUTO_DOWNLOAD_IGNORE_REUPLOADS_VALUE="true"
DOWNLOAD_AS_CBZ_VALUE="true"

if [ -f "${OPTIONS_FILE}" ] && command -v jq >/dev/null 2>&1; then
  TZ_VALUE="$(jq -r '.tz // "Europe/Rome"' "${OPTIONS_FILE}")"
  UPDATE_INTERVAL_VALUE="$(jq -r '.update_interval // 12' "${OPTIONS_FILE}")"
  UPDATE_MANGA_INFO_VALUE="$(jq -r '.update_manga_info // false' "${OPTIONS_FILE}")"
  UPDATE_EXCLUDE_STARTED_VALUE="$(jq -r '.update_exclude_started // false' "${OPTIONS_FILE}")"
  UPDATE_EXCLUDE_COMPLETED_VALUE="$(jq -r '.update_exclude_completed // true' "${OPTIONS_FILE}")"
  WEB_UI_UPDATE_INTERVAL_VALUE="$(jq -r '.web_ui_update_interval // 0' "${OPTIONS_FILE}")"
  AUTO_DOWNLOAD_CHAPTERS_VALUE="$(jq -r '.auto_download_chapters // true' "${OPTIONS_FILE}")"
  AUTO_DOWNLOAD_EXCLUDE_UNREAD_VALUE="$(jq -r '.auto_download_exclude_unread // true' "${OPTIONS_FILE}")"
  AUTO_DOWNLOAD_NEW_CHAPTERS_LIMIT_VALUE="$(jq -r '.auto_download_new_chapters_limit // 5' "${OPTIONS_FILE}")"
  AUTO_DOWNLOAD_IGNORE_REUPLOADS_VALUE="$(jq -r '.auto_download_ignore_reuploads // true' "${OPTIONS_FILE}")"
  DOWNLOAD_AS_CBZ_VALUE="$(jq -r '.download_as_cbz // true' "${OPTIONS_FILE}")"
fi

export TZ="${TZ_VALUE}"

export BIND_IP="0.0.0.0"
export BIND_PORT="4567"

export UPDATE_INTERVAL="${UPDATE_INTERVAL_VALUE}"
export UPDATE_MANGA_INFO="${UPDATE_MANGA_INFO_VALUE}"
export UPDATE_EXCLUDE_STARTED="${UPDATE_EXCLUDE_STARTED_VALUE}"
export UPDATE_EXCLUDE_COMPLETED="${UPDATE_EXCLUDE_COMPLETED_VALUE}"
export WEB_UI_UPDATE_INTERVAL="${WEB_UI_UPDATE_INTERVAL_VALUE}"

export AUTO_DOWNLOAD_CHAPTERS="${AUTO_DOWNLOAD_CHAPTERS_VALUE}"
export AUTO_DOWNLOAD_EXCLUDE_UNREAD="${AUTO_DOWNLOAD_EXCLUDE_UNREAD_VALUE}"
export AUTO_DOWNLOAD_NEW_CHAPTERS_LIMIT="${AUTO_DOWNLOAD_NEW_CHAPTERS_LIMIT_VALUE}"
export AUTO_DOWNLOAD_IGNORE_REUPLOADS="${AUTO_DOWNLOAD_IGNORE_REUPLOADS_VALUE}"
export DOWNLOAD_AS_CBZ="${DOWNLOAD_AS_CBZ_VALUE}"

echo "Starting Suwayomi with:"
echo "TZ=${TZ}"
echo "UPDATE_INTERVAL=${UPDATE_INTERVAL}"
echo "UPDATE_MANGA_INFO=${UPDATE_MANGA_INFO}"
echo "UPDATE_EXCLUDE_STARTED=${UPDATE_EXCLUDE_STARTED}"
echo "UPDATE_EXCLUDE_COMPLETED=${UPDATE_EXCLUDE_COMPLETED}"
echo "WEB_UI_UPDATE_INTERVAL=${WEB_UI_UPDATE_INTERVAL}"
echo "AUTO_DOWNLOAD_CHAPTERS=${AUTO_DOWNLOAD_CHAPTERS}"
echo "AUTO_DOWNLOAD_EXCLUDE_UNREAD=${AUTO_DOWNLOAD_EXCLUDE_UNREAD}"
echo "AUTO_DOWNLOAD_NEW_CHAPTERS_LIMIT=${AUTO_DOWNLOAD_NEW_CHAPTERS_LIMIT}"
echo "AUTO_DOWNLOAD_IGNORE_REUPLOADS=${AUTO_DOWNLOAD_IGNORE_REUPLOADS}"
echo "DOWNLOAD_AS_CBZ=${DOWNLOAD_AS_CBZ}"

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

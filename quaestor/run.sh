#!/usr/bin/env bash
set -euo pipefail

OPTIONS_FILE=/data/options.json

get_option() {
    jq -r --arg key "$1" '.[$key] // empty' "$OPTIONS_FILE"
}

export DATABASE_ENCRYPTION_KEY="$(get_option database_encryption_key)"
export ALLOW_NEW_USER_REGISTRATION="$(get_option allow_new_user_registration)"
export DEFAULT_LANGUAGE="$(get_option default_language)"
export DEFAULT_CURRENCY="$(get_option default_currency)"
export DISPLAY_TIMEZONE="$(get_option display_timezone)"
export LOG_LEVEL="$(get_option log_level)"
export SYNC_INTERVAL_HOURS="$(get_option sync_interval_hours)"
export MAX_ATTACHMENT_SIZE_MB="$(get_option max_attachment_size_mb)"

# Only set if configured, so the app's own default (127.0.0.1) applies otherwise.
forwarded_allow_ips="$(get_option forwarded_allow_ips)"
if [[ -n "${forwarded_allow_ips}" ]]; then
    export FORWARDED_ALLOW_IPS="${forwarded_allow_ips}"
fi

export HOST=0.0.0.0
export PORT=8000
export DATA_DIR=/data

if [[ -z "${DATABASE_ENCRYPTION_KEY}" ]]; then
    echo "[quaestor-addon] database_encryption_key is not set in the add-on configuration. Set it under Settings before starting." >&2
    exit 1
fi

# /data is bind-mounted by the Supervisor and owned by root; the app runs as
# the unprivileged 'app' user (uid 1000) baked into the upstream image.
chown -R app:app /data

exec runuser -u app --preserve-environment -- python -m source.backend.server

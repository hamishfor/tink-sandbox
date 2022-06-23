#!/usr/bin/env bash

# This script handles uploading containers from one container registry to another.
# It assumes the target registry requires username and password authentication.

set -euo pipefail

user=$1
pass=$2
url=$3
tink_image=$4
images=$5

mapfile -t lines < <(sed 's|@TINK_WORKER_IMAGE@|'"$tink_image"'|' "$images")
printf "syncing:\n" >&2
printf "%s\n" "${lines[@]}" | sed 's| | → |' >&2
for l in "${lines[@]}"; do
	read -r src dest <<<"$l"
	echo "::::: syncying $src → $url/$dest :::::" >&2
	skopeo copy --all --dest-tls-verify=false --dest-creds="$user:$pass" "docker://$src" "docker://$url/$dest"
done

#!/bin/bash
set -e

if [[ -n "$INPUT_CA_CERTIFICATE" ]]; then
  echo "$INPUT_CA_CERTIFICATE" >> /usr/local/share/ca-certificates/mender-server.crt
fi

update-ca-certificates

# shellcheck disable=SC2086
./single-file-artifact-gen \
  -n "$INPUT_ARTIFACT_NAME" \
  -t ${INPUT_DEVICE_TYPE// / -t } \
  -d "${INPUT_DESTINATION_DIRECTORY}" \
  -o "$INPUT_ARTIFACT_NAME".mender "${INPUT_FILE}"

mender-cli login \
  --server "$INPUT_SERVER_ADDRESS" \
  --username "$INPUT_USERNAME" \
  --password "$INPUT_PASSWORD"

mender-cli artifacts \
  --server https://mender.albeeconnect.co.uk \
  upload \
  "$INPUT_ARTIFACT_NAME".mender
#!/bin/bash

bash_major="${BASH_VERSINFO[0]}"
bash_minor="${BASH_VERSINFO[1]}"

if (( bash_major < 4 )); then
    echo "ERROR: Bash version $BASH_VERSION is too old. Required: 4.0 or higher" >&2
    exit 1
fi

THIS_DIR=$(cd $(dirname ${BASH_SOURCE}) && pwd)

set -e

# Expected environment example:
#   SO_APP_NAME=nextjs-app
#   SO_APP_VERSION=0.1.0
# Custom environment:
#   APP_CUSTOM_ARG=

echo "Starting script $0 (Bash $bash_major.$bash_minor)"
echo "SO_APP_NAME=${SO_APP_NAME}"
echo "SO_APP_VERSION=${SO_APP_VERSION}"
echo "Custom environment:"
echo "APP_CUSTOM_ARG=${APP_CUSTOM_ARG}"

DOCKERFILE=Dockerfile

PACKAGE_JSON="${THIS_DIR}/package.json"

# Extract name and version from package.json without jq
PKG_NAME=$(grep '"name"' "$PACKAGE_JSON" | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
PKG_VERSION=$(grep '"version"' "$PACKAGE_JSON" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [[ -n "${SO_APP_VERSION}" && ${SO_APP_VERSION} != "latest" ]]; then
    if [[ ${SO_APP_VERSION} != ${PKG_VERSION} ]]; then
        echo "Invalid application version!" >&2
        echo "Current version from package.json is ${PKG_VERSION}, but ${SO_APP_VERSION} is expected." >&2
        echo "Is a valid source code commit selected?" >&2
        exit 1
    fi
fi

if [[ -z ${SO_APP_NAME} ]]; then
    # Convert to lowercase to be used as tag
    APP_NAME="${PKG_NAME,,}"
else
    APP_NAME=${SO_APP_NAME}
fi

APP_VERSION=${PKG_VERSION}

APP_RESPONSE='Built with Shell'
if [[ -n "${APP_CUSTOM_ARG}" ]]; then
    APP_RESPONSE="${APP_RESPONSE} (${APP_CUSTOM_ARG})"
fi

pushd ${THIS_DIR} >/dev/null
docker build -t ${APP_NAME}:${APP_VERSION} --build-arg APP_RESPONSE="${APP_RESPONSE}" -f ${DOCKERFILE} .
popd >/dev/null



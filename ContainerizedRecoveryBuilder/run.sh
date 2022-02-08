#!/usr/bin/env bash

set -o errexit -o pipefail

function main() {
    if [ "${UID:-}" = '0' ] || [ "${__USER_IDS__['uid']}" = '0' ]; then
        printf "Do not execute this script using sudo.\n" >&2
        printf "You will get sudo prompt in case root privileges are needed.\n" >&2
        exit 1
    fi

    mkdir -p .home/ \
        src/{out,.repo/local_manifests/} \
        ccache

    if [ -d local_manifests ]; then
        rsync --archive \
            --delete \
            --include '*/' \
            --include '*.xml' \
            --exclude '*' \
            local_manifests/ src/.repo/local_manifests/ || exit $?
    fi

    local home="/home/${__USER_IDS__['name']}"

    if ! sudo docker inspect --type image "$__IMAGE_TAG__" &> /dev/null; then
        printf "Note: Unable to find '%s' image. Start building...\n" "$__IMAGE_TAG__" >&2
        printf "This may take a while...\n\n" >&2
        sudo DOCKER_BUILDKIT=1 docker build \
            --no-cache \
            --build-arg USER="${__USER_IDS__['name']}" \
            --build-arg UID="${__USER_IDS__['uid']}" \
            --build-arg GID="${__USER_IDS__['gid']}" \
            --tag "$__IMAGE_TAG__" "$__DIR__"/Dockerfile/ || exit $?

        printf "We're almost there...\n" >&2
        sudo docker run \
            --interactive \
            --rm \
            --name "$__CONTAINER_NAME__" \
            --detach=true \
            "$__IMAGE_TAG__" >&2 || exit $?

        sudo docker container cp \
            --archive \
            "$__CONTAINER_NAME__":"$home"/. .home &&

        # TODO: this is a workaround because '--archive' argument for 'docker
        # container cp' command is broken. Check from time to time if it has
        # been fixed.
        sudo find .home -exec chown \
            --silent \
            --recursive \
            "${__USER_IDS__['uid']}":"${__USER_IDS__['gid']}" \
            {} \+ || exit $?

        printf "Finishing...\n" >&2
        sudo docker container stop "$__CONTAINER_NAME__" >/dev/null || exit $?
    fi

    local entrypoint=/mnt/entrypoint.sh
    sudo docker run \
        --tty \
        --interactive \
        --rm \
        --name "$__CONTAINER_NAME__" \
        --tmpfs /tmp:rw,exec,nosuid,nodev,uid="${__USER_IDS__['uid']}",gid="${__USER_IDS__['gid']}" \
        --privileged \
        --env TZ="$(timedatectl | awk '/Time zone:/ { print $3 }')" \
        --env-file "$PWD"/env.list \
        --volume /etc/timezone:/etc/timezone:ro \
        --volume /etc/localtime:/etc/localtime:ro \
        --volume "$__DIR__"/entrypoint.sh:"$entrypoint" \
        --volume "$PWD"/src/out:/mnt/src/out \
        --volume "$PWD"/ccache:/mnt/ccache \
        --volume "$PWD"/src:/mnt/src \
        --volume "$PWD"/.home:"$home" \
        "$__IMAGE_TAG__" "$entrypoint"
}

__DIR__="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly __DIR__
readonly __CONTAINER_NAME__='containerized_recovery_builder'
readonly __REPOSITORY__="iusmac/$__CONTAINER_NAME__"
readonly __IMAGE_TAG__="$__REPOSITORY__:v1.0"
declare -rA __USER_IDS__=(
    ['name']="$USER"
    ['uid']="$(id --user "$USER")"
    ['gid']="$(id --group "$USER")"
)

main

#!/usr/bin/env bash

__JOBS__="$(nproc --all)"
readonly __JOBS__

function main() {
    # Repo tool requires python3
    pyenv latest global 3.9

    if __confirm__ 'Init repo?'; then
        yes | repo init \
            --depth=1 \
            --groups=default,-mips,-darwin \
            --manifest-url="$MANIFEST_URL" \
            --manifest-branch="$MANIFEST_BRANCH" || exit $?
    fi

    if __confirm__ 'Sync sources?'; then
        repo sync \
            --current-branch \
            --fail-fast \
            --force-sync \
            --no-clone-bundle \
            --no-tags \
            --optimized-fetch \
            --jobs="$__JOBS__" || exit $?
    fi

    if __confirm__ 'Build recovery?'; then
        ccache --max-size "$CCACHE_SIZE"

        # Forcefully point to out/ dir because we're mounting this
        # directory from the outside and somehow it changes to an absolute
        # path. This will force Soong to look for things in out/ dir using
        # the absolute path and fail if we will change the mount point for
        # some reason.
        export OUT_DIR=out

        # OrangeFox requires python2
        pyenv latest global 2.7

        # shellcheck disable=SC1091
        source build/envsetup.sh &&
        lunch "omni_$FOX_BUILD_DEVICE-eng" &&
        mka -j"$__JOBS__" recoveryimage
    fi
}

function __confirm__() {

    while true; do
        read -rp "- ${1-} [Y/n] "

        if [ "$REPLY" = 'Y' ]; then
            return 0
        elif [ "$REPLY" = 'n' ]; then
            return 1
        fi
    done
}

main

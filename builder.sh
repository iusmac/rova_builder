#!/usr/bin/env bash

# NOTE: If you like me have an 8GB RAM machine, change in the line below
# 'false' to 'true' so that the build does not fail with an 'Out of memory'
# error.
if false && [ -d src/build/soong ]; then
    git -C src/build/soong reset --hard &&
    git -C src/build/soong clean -d --force &&
    git apply \
        --directory=src/ \
        --verbose \
        --whitespace=fix \
        "$PWD"/patches/droiddoc-now-buildable-on-8GB-RAM-Machines.patch || exit $?
fi

bash ContainerizedAndroidBuilder/run.sh \
    --android '11.0'  \
    --repo-url 'https://github.com/crdroidandroid/android.git' \
    --repo-revision '11.0' \
    --lunch-system 'lineage' \
    --lunch-device 'rova' \
    --lunch-flavor 'userdebug' \
    --ccache-size '50G' \
    --move-zips 1

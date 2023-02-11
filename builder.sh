#!/usr/bin/env bash

bash ContainerizedAndroidBuilder/run.sh \
    --android '13.0'  \
    --repo-url 'https://github.com/crdroidandroid/android.git' \
    --repo-revision '13.0' \
    --lunch-system 'lineage' \
    --lunch-device 'rova' \
    --lunch-flavor 'user' \
    --ccache-size '50G' \
    --move-zips 1

#!/usr/bin/env bash

bash ContainerizedAndroidBuilder/run.sh \
    --email 'iusico.maxim@libero.it' \
    --repo-url 'https://github.com/crdroidandroid/android.git' \
    --repo-revision '13.0' \
    --lunch-system 'lineage' \
    --lunch-device 'rova' \
    --lunch-flavor 'userdebug' \
    --ccache-size '50G' \
    --move-zips 1

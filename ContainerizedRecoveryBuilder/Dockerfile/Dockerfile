FROM debian:bullseye

ARG USER
ARG UID
ARG GID

# Environment variables
#---------------------#
ENV DEBIAN_FRONTEND noninteractive
ENV SRC_DIR /mnt/src
ENV OUT_DIR /mnt/src/out
ENV CCACHE_DIR /mnt/ccache
ENV CCACHE_EXEC /usr/bin/ccache

# Create host user
#----------------#
RUN groupadd --gid $GID $USER && \
    useradd --uid $UID \
        --gid $GID \
        --no-log-init \
        --create-home \
        --shell /bin/bash \
        $USER

# Delcare volume list
#-------------------#
VOLUME $SRC_DIR
VOLUME $OUT_DIR
VOLUME $CCACHE_DIR

# Create volum directories
#------------------------#
RUN mkdir -p $SRC_DIR/ $OUT_DIR/ $CCACHE_DIR/

# Install build dependencies
#--------------------------#
RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get install -y \
            --no-install-recommends \
            git aria2 openssl ca-certificates \
            gnupg curl wget ssh

RUN git clone --depth=1 https://gitlab.com/OrangeFox/misc/scripts /tmp/scripts
RUN cd /tmp/scripts; \
    cat setup/android_build_env.sh \
        setup/install_android_sdk.sh | \
    sed 's/sudo //g' | \
    sed '/apt install lsb-core/d' | \
    sed 's/apt install/apt install --no-install-recommends/g' | \
    sed 's/apt /apt-get /g' | bash 

# Use pyenv shims for python instead
#----------------------------------#
ENV PYENV_ROOT="/home/$USER/.pyenv"
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git $PYENV_ROOT
RUN apt-get remove -y python*
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
RUN git clone --depth=1 https://github.com/momo-lab/xxenv-latest.git \
                        "$(pyenv root)"/plugins/xxenv-latest
RUN apt-get install -y \
            --no-install-recommends \
            make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
            libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
            libffi-dev liblzma-dev
RUN pyenv latest install 2.7
RUN pyenv latest install 3.9

# Run everything as non-root
#--------------------------#
RUN find /home/$USER/ /mnt -exec chown \
        --silent \
        --recursive \
        $USER:$USER \
        {} \+

USER $USER

# Set-up configs
#--------------#
RUN git config --global user.name $USER
RUN git config --global user.email test@localhost

# Set work directory
#------------------#
WORKDIR $SRC_DIR

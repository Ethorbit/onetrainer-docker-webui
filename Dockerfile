ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-cuda-focal"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG AS base

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

USER root

######### Customize Container Here ###########
ENV PYTHONUNBUFFERED=1

# SYSTEM
RUN apt-get update --yes --quiet && DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    software-properties-common \
    build-essential apt-utils \
    wget curl vim git ca-certificates kmod \
    nvidia-driver-525 \
 && rm -rf /var/lib/apt/lists/*

# PYTHON 3.10
RUN add-apt-repository --yes ppa:deadsnakes/ppa && apt-get update --yes --quiet
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    python3.10 \
    python3.10-dev \
    python3.10-distutils \
    python3.10-lib2to3 \
    python3.10-gdbm \
    python3.10-tk \
    pip

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 999 \
    && update-alternatives --config python3 && ln -s /usr/bin/python3 /usr/bin/python

RUN curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py --upgrade pip setuptools wheel \
    && rm get-pip.py

# Create and set the working directory
RUN mkdir -p /OneTrainer
WORKDIR /OneTrainer

# Copy the current directory's contents to the container image
COPY ./OneTrainer /OneTrainer
WORKDIR /OneTrainer

# Install requirements
RUN python3 --version
RUN python3 -m pip install --ignore-installed -r requirements.txt

# Update the desktop environment to be optimized for a single application
RUN cp /home/kasm-default-profile/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* /home/kasm-default-profile/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/backgrounds/bg_kasm.png /usr/share/backgrounds/bg_default.png
RUN rm /usr/bin/xfce4-panel
# This just breaks the image, above is the workaround
# apt-get remove -y xfce4-panel

#
# I will now proceed to fix errors because no one's stuff ever works :D
#

RUN echo "Fixing: ModuleNotFoundError: No module named 'cups'" &&\
    apt-get purge -y system-config-printer
######### End Customizations ###########

RUN chown -R 1000:0 /home/kasm-default-profile/ &&\
    chown -R 1000:0 /OneTrainer/

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

COPY --chmod=0755 ./custom_startup.sh $STARTUPDIR/custom_startup.sh

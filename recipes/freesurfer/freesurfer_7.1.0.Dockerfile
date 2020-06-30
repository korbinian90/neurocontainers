# Generated by: Neurodocker version 0+unknown
# Latest release: Neurodocker version 0.7.0
# Timestamp: 2020/06/30 16:45:41 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/ReproNim/neurodocker

FROM centos:7

USER root

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && yum install -y -q \
           bzip2 \
           ca-certificates \
           curl \
           epel-release \
           localedef \
           unzip \
    && yum clean packages \
    && rm -rf /var/cache/yum/* \
    && localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

RUN printf '#!/bin/bash\nls -la' > /usr/bin/ll

RUN chmod +x /usr/bin/ll

RUN mkdir /afm01 /90days /30days /QRISdata /RDS /data /short /proc_temp /TMPDIR /nvme /local /gpfs1 /working /winmounts /state /autofs /cluster /local_mount /scratch /clusterdata /nvmescratch

ENV FREESURFER_HOME="/opt/freesurfer-7.1.0" \
    PATH="/opt/freesurfer-7.1.0/bin:$PATH"
RUN yum install -y -q \
           bc \
           epel-release \
           libXScrnSaver \
           libXft \
           libXmu \
           libXt \
           libgomp \
           libjpeg-turbo \
           mesa-libEGL \
           mesa-libGLU \
           perl \
           qt-x11 \
           qt5-qtbase-gui \
           qt5-qtdeclarative \
           qt5-qtx11extras \
           tcsh \
    && yum clean packages \
    && rm -rf /var/cache/yum/* \
    && echo "Downloading FreeSurfer ..." \
    && mkdir -p /opt/freesurfer-7.1.0 \
    && curl -fsSL --retry 5 https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.1.0/freesurfer-linux-centos6_x86_64-7.1.0.tar.gz \
    | tar -xz -C /opt/freesurfer-7.1.0 --strip-components 1 \
         --exclude='freesurfer/average/mult-comp-cor' \
         --exclude='freesurfer/lib/cuda' \
         --exclude='freesurfer/subjects/V1_average' \
         --exclude='freesurfer/subjects/bert' \
         --exclude='freesurfer/subjects/cvs_avg35' \
         --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
         --exclude='freesurfer/subjects/fsaverage3' \
         --exclude='freesurfer/subjects/fsaverage4' \
         --exclude='freesurfer/subjects/fsaverage5' \
         --exclude='freesurfer/subjects/fsaverage6' \
         --exclude='freesurfer/subjects/fsaverage_sym' \
         --exclude='freesurfer/trctrain' \
    && sed -i '$isource "/opt/freesurfer-7.1.0/SetUpFreeSurfer.sh"' "$ND_ENTRYPOINT"

ENV DEPLOY_PATH="/opt/freesurfer-7.1.0/bin/"

RUN test "$(getent passwd neuro)" || useradd --no-user-group --create-home --shell /bin/bash neuro
USER neuro

RUN echo '{ \
    \n  "pkg_manager": "yum", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "centos:7" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "printf '"'"'#!/bin/bash\\\nls -la'"'"' > /usr/bin/ll" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "chmod +x /usr/bin/ll" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir /afm01 /90days /30days /QRISdata /RDS /data /short /proc_temp /TMPDIR /nvme /local /gpfs1 /working /winmounts /state /autofs /cluster /local_mount /scratch /clusterdata /nvmescratch" \
    \n    ], \
    \n    [ \
    \n      "freesurfer", \
    \n      { \
    \n        "version": "7.1.0" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "DEPLOY_PATH": "/opt/freesurfer-7.1.0/bin/" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json

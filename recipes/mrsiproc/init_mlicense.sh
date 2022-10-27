#!/usr/bin/env bash
set -e

if ! [ -d /home/user/Downloads ]; then
    mkdir /home/user/Downloads
fi

MLICENSE_EXTERN=/neurodesktop-storage/license_matlab.lic
MLICENSE_DOWNLOADS=/home/user/Downloads/license.lic

# if no license file is present call matlab GUI
if ! [[ -f "$MLICENSE_EXTERN" || -f "$MLICENSE_DOWNLOADS" ]]; then
    matlab
fi

# if the license file is present in only one place copy to both places
if ! [[ -f "$MLICENSE_EXTERN" && -f "$MLICENSE_DOWNLOADS" ]]; then
    
    if [ -f "$MLICENSE_EXTERN" ]; then
        cp $MLICENSE_EXTERN $MLICENSE_DOWNLOADS
    else
        cp $MLICENSE_DOWNLOADS $MLICENSE_EXTERN
    fi

fi

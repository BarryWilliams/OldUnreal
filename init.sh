#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo. This is required for the file overlays."
    exit 1
fi

echo "Setting environment variables"

set -a
source environment-variables.env
set +a

: ${FOLDER_OVERLAY_0_COMPILED:=/ut_compiled}
: ${FOLDER_OVERLAY_1_UPPER_USER_FILES:=/1-upper_user-files}
: ${FOLDER_OVERLAY_2_MIDDLE_OLDUNREAL:=/2-middle_oldunreal}
: ${FOLDER_OVERLAY_3_LOWER_UT_ORIGINALS:=/3-lower_ut-originals}

mkdir -p $FOLDER_OVERLAY_1_UPPER_USER_FILES/Sounds
mkdir -p $FOLDER_OVERLAY_1_UPPER_USER_FILES/Music
mkdir -p $FOLDER_OVERLAY_1_UPPER_USER_FILES/Maps
mkdir -p $FOLDER_OVERLAY_1_UPPER_USER_FILES/Textures
mkdir -p $FOLDER_OVERLAY_1_UPPER_USER_FILES/System

echo "Keep this folder blank unless necessary" > $FOLDER_OVERLAY_1_UPPER_USER_FILES/System/KEEP_THIS_FOLDER_BLANK_UNLESS_NECESSARY

echo "File watcher started, monitoring for changes in original UT files folder. Now is the time to upload these files."

inotifywait -r -e modify,create,delete "$FOLDER_OVERLAY_3_LOWER_UT_ORIGINALS"

echo "Files changed!"

while inotifywait -t 5 -r -e modify,create,delete "$FOLDER_OVERLAY_3_LOWER_UT_ORIGINALS"; do
        echo "File changes occured"
        sleep 5
        echo "Watching for additional changes..."
done

echo "No additional changes detected. Exiting"
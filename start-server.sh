#!/bin/bash -v
set -e

echo "Setting environment variables"

set -a
source environment-variables.env
set +a

export UT_ADMINEMAIL='"no@one.com"'
export UT_ADMINNAME='"UTAdmin"'
export UT_ADMINPWD='"admin"'
export UT_INITIALBOTS_CTF="8"
export UT_INITIALBOTS_DM="4"
export UT_MINPLAYERS_CTF="8"
export UT_MINPLAYERS_DM="4"
export UT_MOTD1='"Have Fun"'
export UT_SERVERNAME='"My UT Server"'
export UT_SERVERURL='"CTF-Face?game=BotPack.CTFGame?mutator=BotPack.InstaGibDM"'
export UT_WEBADMINPWD='"admin"'
export UT_WEBADMINUSER='"admin"'

export FOLDER_UT_COMPILED=/ut_compiled
export FOLDER_1_UPPER_USER_FILES=/1-upper_user-files
export FOLDER_2_MIDDLE_OLDUNREAL=/2-middle_oldunreal
export FOLDER_3_LOWER_UT_ORIGINALS=/3-lower_ut-originals

echo "Compiling Files..."

mkdir -p $FOLDER_UT_COMPILED
mkdir -p $FOLDER_1_UPPER_USER_FILES
mkdir -p $FOLDER_2_MIDDLE_OLDUNREAL
mkdir -p $FOLDER_3_LOWER_UT_ORIGINALS

mkdir -p $FOLDER_1_UPPER_USER_FILES/Sounds
mkdir -p $FOLDER_1_UPPER_USER_FILES/Music
mkdir -p $FOLDER_1_UPPER_USER_FILES/Maps
mkdir -p $FOLDER_1_UPPER_USER_FILES/Textures
mkdir -p $FOLDER_1_UPPER_USER_FILES/System64

rm -rf "$FOLDER_3_LOWER_UT_ORIGINALS"/System

echo -e "\n\n** Copying the base files **"
rsync -a --stats "$FOLDER_3_LOWER_UT_ORIGINALS"/ "$FOLDER_UT_COMPILED"

echo -e "\n\n** Overlaying OldUnreal patch **"
rsync -a --stats "$FOLDER_2_MIDDLE_OLDUNREAL"/ "$FOLDER_UT_COMPILED"

echo -e "\n\n** Copying user files **"
rsync -av --stats "$FOLDER_1_UPPER_USER_FILES"/ "$FOLDER_UT_COMPILED"

echo $(env)

echo "Starting the server. Happy hunting."
cd "$FOLDER_UT_COMPILED"/System64/

#"$FOLDER_UT_COMPILED"/System64/ucc-bin-amd64 server $UT_SERVERURL ini="$FOLDER_UT_COMPILED"/System64/UnrealTournament.ini -nohomedir -lanplay
"$FOLDER_UT_COMPILED"/System64/ucc-bin-amd64 server $UT_SERVERURL ini=UnrealTournament.ini log=ut.log -nohomedir
#!/bin/bash

mkdir -p original-files
mkdir -p user-files
mkdir -p ut-compiled

if [ -z "$( ls -A 'original-files' )" ]; then
   echo "Please add original game files to directory 'original-files'"
   exit 1
fi
docker kill oldunreal
docker rm oldunreal

docker run -it --name oldunreal -v $(pwd)/user-files:/1-upper_user-files -v $(pwd)/original-files:/3-lower_ut-originals -v $(pwd)/ut-compiled:/ut_compiled -p 5580:5580/tcp -p 7777:7777/udp -p 7778:7778/udp -p 7779:7779/udp -p 7780:7780/udp -p 7781:7781/udp -p 8777:8777/udp -p 27500:27500/tcp -p 27500:27500/udp -p 27900:27900/tcp -p 27900:27900/udp oldunreal:469e $1

docker rm oldunreal
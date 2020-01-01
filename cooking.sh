#!/bin/bash
# Init Variable
oldPWD=$PWD
uproject=`ls "$oldPWD"/*.uproject`

#Writable Variables
UE4DIR="/opt/UE4"
OUTPUT="$oldPWD/Build"
CPFiles="README LICENSE CHANGELOG"
VERSION="0.0.1"
PROFILE="Development"

if [ ! -d $OUTPUT  ];then mkdir -p $OUTPUT
fi
cd $UE4DIR

Engine/Build/BatchFiles/RunUAT.sh \
BuildCookRun \
	-project="$uproject" -noP4 -platform=Linux \
 	-clientconfig=$PROFILE \
	-cook -compressed -allmaps -build -stage -pak -archive \
	-archivedirectory="$OUTPUT"
cd $oldPWD
for file in $CPFiles; do
    if [[ -f "$file" ]]; then
        cp $file "$OUTPUT"/*/
    fi
done

7z a -t7z $(basename "$uproject" .uproject)-Linux-$VERSION.7z -m0=lzma2 -mx=9 -aoa -mmt=on "$OUTPUT"/*/*

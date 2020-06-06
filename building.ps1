<#
///-----------------------------------------------------------------
///   Author:   Gabriel Bustillo del Cuvillo
///   License:  Apache License 2.0
///   Original Repo: https://github.com/gabuscuv/UE4-Toolkit-Public
///-----------------------------------------------------------------
#>
# Init Variable
$oldPWD=(Get-Location).Path
$uproject=(Get-ChildItem *.uproject).FullName

#Writable Variables
$UE4DIR="E:\Program Files\Epic Games\UE_*"
$PROFILE="Development"

cd $UE4DIR

Engine/Build/BatchFiles/RunUAT.bat `
BuildCookRun `
    -project="$uproject" -noP4 `
    -platform=Win64 -clientconfig="$PROFILE" -build
PAUSE
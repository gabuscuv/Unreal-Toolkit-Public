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
$7ZDIR="C:\Program Files\7-Zip"
$OUTPUT="$oldPWD\Builds"
$CPFiles=@("README.md","LICENSE","CHANGELOG.txt")
$VERSION="0.0.1"
$PROFILE="Development"
$ARCH="Win64"

if (!(Test-Path $OUTPUT -PathType Container))
{
    mkdir -p $OUTPUT
}

cd $UE4DIR

Engine/Build/BatchFiles/RunUAT.bat `
BuildCookRun `
    -project="$uproject" -noP4 -platform="$ARCH" `
 	-clientconfig="$PROFILE" `
    -cook -compressed -allmaps -build -stage -pak -archive `
    -archivedirectory="$OUTPUT"

cd $oldPWD

for($i=0; $i -lt $CPFiles.Length; $i++)
{
    if(Test-Path -Path $CPFiles[$i] -PathType Leaf)
    {
        cp $CPFiles[$i] (Get-ChildItem "$OUTPUT").FullName
    }
}

$temp=[IO.Path]::GetFileNameWithoutExtension($uproject)

& "$7ZDIR\7z.exe" a -t7z "$temp-$ARCH-$VERSION.7z" -m0=lzma2 -mx=9 -aoa -mmt=on "$OUTPUT\*\*"
PAUSE
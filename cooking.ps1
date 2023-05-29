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
$OUTPUT="H:\Stages"
$CPFiles=@("README.md","LICENSE","CHANGELOG.txt")
$VERSION="0.1.0-UE4" ## previous: 0.0.9j
$PROFILE="Shipping"
$ITCHREPO="userblah/Project1"
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
    -cook -compressed -build -stage -pak -archive `
    -CreateReleaseVersion="1.0" `
    -archivedirectory="$OUTPUT"

cd $oldPWD

for($i=0; $i -lt $CPFiles.Length; $i++)
{
    if(Test-Path -Path $CPFiles[$i] -PathType Leaf)
    {
        Copy-Item $CPFiles[$i] (Get-ChildItem "$OUTPUT").FullName
    }
}

$temp=[IO.Path]::GetFileNameWithoutExtension($uproject)

if (Test-Path -Path "$oldPWD\Plugins\FMOD\FMODStudio") {
## FMOD Plugins and Libraries
Copy-Item "$oldPWD\Plugins\FMOD\FMODStudio\Binaries\Win64\*L*.dll" "$OUTPUT\WindowsNoEditor\$temp\Plugins\FMOD\FMODStudio\Binaries\Win64\"
Copy-Item "$oldPWD\Plugins\FMOD\FMODStudio\Binaries\Win64\OculusSpatializerFMOD.dll" "$OUTPUT\WindowsNoEditor\$temp\Plugins\FMOD\FMODStudio\Binaries\Win64\"
}

Copy-Item "$oldPWD\LaunchOptions\*.bat" "$OUTPUT\WindowsNoEditor\"

Rename-Item "$OUTPUT\WindowsNoEditor" "$OUTPUT\$temp"

& butler push $OUTPUT\$temp $ITCHREPO':'$ARCH --userversion "$VERSION"
& "$7ZDIR\7z.exe" a -t7z "$OUTPUT\$temp-$ARCH-$VERSION.7z" -m0=lzma2 -mx=9 -aoa -mmt=on "$OUTPUT\*\*"
PAUSE
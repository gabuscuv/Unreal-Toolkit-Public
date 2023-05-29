$oldPWD=(Get-Location).Path
$uproject=(Get-ChildItem *.uproject).FullName

#Writable Variables
$UE4DIR="E:\Program Files\Epic Games\UE_*"
$7ZDIR="C:\Program Files\7-Zip"
$OUTPUT="H:\Stages"
$CPFiles=@("README.md","LICENSE","CHANGELOG.txt")
$VERSION="0.0.1"
$PROFILE="Shipping"
$ITCHREPO=""
$ARCH="Win64"

$temp=[IO.Path]::GetFileNameWithoutExtension($uproject)

& butler push $OUTPUT\$temp $ITCHREPO':'$ARCH --userversion "$VERSION"
& "$7ZDIR\7z.exe" a -t7z "$OUTPUT\$temp-$ARCH-$VERSION.7z" -m0=lzma2 -mx=9 -aoa -mmt=on "$OUTPUT\*\*"
PAUSE 
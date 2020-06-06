<#
///-----------------------------------------------------------------
///   Author:   Gabriel Bustillo del Cuvillo
///   License:  Apache License 2.0
///   Original Repo: https://github.com/gabuscuv/UE4-Toolkit-Public
///-----------------------------------------------------------------
#>
$Name=""
$Email=""
$SSHKey=""
$UE4DIR="E:\Program Files\Epic Games\UE_*"

if(! (Get-Command git-lfs -errorAction SilentlyContinue))
{ echo "This repo require git-lfs but it's not installed.  Aborting."; exit 1; }
echo "Installing git-lfs."
git lfs install
echo "Setting up Git Credentials."
git config --local user.name "$Name"
git config --local user.email "$Email"
git config core.sshCommand "ssh -i $SSHKey -F /dev/null"

if (Test-Path -Path (Get-ChildItem *.uproject) -PathType Leaf){
echo "Detected UE4 Project, Generating files."
$oldPWD=(Get-Location).Path
$uproject=(Get-ChildItem *.uproject).FullName

cd $UE4DIR

Engine/Build/BatchFiles/RunUAT.bat `
BuildCookRun `
    -project="$uproject" -noP4 -platform=Win64 `
    -clientconfig=Development `
    -build
cd $oldPWD
}

git update-index --assume-unchanged ".\init-repo.lnk"
rm init-repo.lnk
PAUSE

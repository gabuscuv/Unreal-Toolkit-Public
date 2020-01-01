#!/bin/sh

Name=""
Email=""
SSHKey="$HOME/.ssh/id_rsa"
UE4DIR="/opt/UE4"

hash git-lfs 2>/dev/null || { echo >&2 "This repo require git-lfs but it's not installed.  Aborting."; exit 1; }
echo "Installing git-lfs."
git lfs install
echo "Setting up Git Credentials."
git config --local user.name "$Name"
git config --local user.email "$Email"
git config core.sshCommand "ssh -i $SSHKey -F /dev/null"

if [ -f *.uproject ];then
echo "Detected UE4 Project, Generating files."
oldPWD=$PWD
uproject=`ls "$oldPWD"/*.uproject`
$UE4DIR/GenerateProjectFiles.sh -project="$uproject" -game -engine -vscode

cd $UE4DIR

Engine/Build/BatchFiles/RunUAT.sh \
BuildCookRun \
	-project="$uproject" -noP4 -platform=Linux \
        -clientconfig=Development \
        -build
cd $oldPWD
fi

git update-index --assume-unchanged ./init-repo.sh
trap "shred -u init-repo.sh" EXIT

#!/usr/bin/env bash

SourceURL='https://github.com/ngosang/trackerslist.git'
FolderName='.trackerslist.git'
FileName='trackers_all.txt'
FolderPath="$HOME/$FolderName"
FullName="$FolderPath/$FileName"

CloneOrPullLatest(){
    echo "[+]Clone or pull latest..."
    if [ -d $FolderPath ];then
        git -C $FolderPath pull
    else
        git clone $SourceURL $FolderPath
    fi
}

UpdateAriaConf(){
    echo "[+]Update aria config..."
    RealOut=$(echo $(grep . ${FullName}) | sed 's/ /,/g')
    sed -i '$ d' $HOME/.aria2/aria2.conf
    echo "bt-tracker=${RealOut}" >> $HOME/.aria2/aria2.conf
}

CloneOrPullLatest
UpdateAriaConf

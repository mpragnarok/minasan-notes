#!/bin/bash

echo "${PWD}"
gstatus=`git status --porcelain`

if [ ${#gstatus} -ne 0 ]
then
    
    git add --all
    #	sleep 10
    git commit -m "$gstatus"
    #	sleep 10
    git pull --rebase
    #	sleep 10
    git push
fi


#!/bin/bash

REPOSITORIES=`pwd`

if [ "$1" != "" ]
then
  REPOSITORIES=$1
fi

NL=$'\n'

for REPO in "$REPOSITORIES"/*
do
  if [ -d "$REPO" ]
  then
    echo "$NL ######################### $NL"
    echo "Updating $(echo $REPO | rev | cut -d'/' -f-1 | rev) at $(date)"
    if [ -d "$REPO/.git" ]
    then
      cd "$REPO"
      BRANCH=$(git rev-parse --abbrev-ref HEAD)
      echo "On branch $BRANCH"
      echo "Fetching master"
      if [ "$BRANCH" = "master" ]
      then
        git pull  
      else
        git fetch origin master:master
      fi
    else
      echo "Skipping because it doesn't look like it has a .git folder."
    fi
    echo "Done at $(date)"
    echo
  else
    echo "$REPO : No such file or directory"
  fi
done

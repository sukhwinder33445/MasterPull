#!/bin/bash

REPOSITORIES=`pwd`

if [ "$1" != "" ]
then
  REPOSITORIES=$1
fi

NL=$'\n'

for REPO in `ls "$REPOSITORIES/"`
do
  if [ -d "$REPOSITORIES/$REPO" ]
  then
    echo "$NL ######################### $NL $NL"
    echo "Updating $REPO at `date`"
    if [ -d "$REPOSITORIES/$REPO/.git" ]
    then
      cd "$REPOSITORIES/$REPO"
      OUTPUT=$(git status)
      BRANCH=${OUTPUT%%$'\n'*}
      echo "$BRANCH"
      echo "Fetching master"
      if [ "$BRANCH" = "On branch master" ]
      then
        git pull  
      else
        git fetch origin master:master
      fi
    else
      echo "Skipping because it doesn't look like it has a .git folder."
    fi
    echo "Done at `date`"
    echo
  fi
done

#!/bin/bash

# Give git repo path as param
# If no param given, .sh file path is default path

REPOSITORIES=`pwd`

if [ "$1" != "" ]
then
  REPOSITORIES=$1
fi

NL=$'\n'

for REPO in "$REPOSITORIES"/*
do
  TO_FETCH_BRANCH='master'
  if [ -d "$REPO" ]
  then
    echo "$NL ######################### $NL"
    echo "Updating $(echo $REPO | rev | cut -d'/' -f-1 | rev) at $(date)"
    if [ -d "$REPO/.git" ]
    then
      cd "$REPO"
      CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
      echo "On branch $CURRENT_BRANCH"
      BRANCHES=$(git branch)

      if [[ $BRANCHES =~ .*main* ]]
      then
        TO_FETCH_BRANCH='main'
      fi
      echo "Fetching branch $TO_FETCH_BRANCH"
      if [ "$CURRENT_BRANCH" = "$TO_FETCH_BRANCH" ]
      then
        git pull
      else
        git fetch origin "$TO_FETCH_BRANCH":"$TO_FETCH_BRANCH"
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

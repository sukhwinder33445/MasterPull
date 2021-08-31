#!/bin/bash

# constants
NEW_LINE=$'\n'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m' # To remove color

#array
FAILED=()
SKIP=()

# Give git repo path as param OR enter path in pathinfo file
# If no param given, .sh file path is default path
REPOSITORIES=`pwd`

REPOS_PATH=$(cat "$REPOSITORIES/fileinfo") # if no file found, default path will be used

if [ "$1" != "" ]; then
  REPOSITORIES=$1
elif [ "$REPOS_PATH" != "" ]; then
  REPOSITORIES=$REPOS_PATH
fi
echo "$NEW_LINE Updating git repos in path: $REPOSITORIES $NEW_LINE"


for REPO in "$REPOSITORIES"/*
do
  TO_FETCH_BRANCH='master'
  if [ -d "$REPO" ]; then # -d checks if the given param is a directory
    REPO_SHORT=$(echo $REPO | rev | cut -d'/' -f-1 | rev)
    echo "$NEW_LINE ######## | $REPO_SHORT | ########"
    echo "Updating at $(date)"
    if [ -d "$REPO/.git" ]; then
      cd "$REPO"
      CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
      echo "On branch $CURRENT_BRANCH"
      BRANCHES=$(git branch)

      if [[ $BRANCHES =~ .*main* ]]; then
        TO_FETCH_BRANCH='main'
      fi

      echo "Fetching branch $TO_FETCH_BRANCH"

      if [ "$CURRENT_BRANCH" = "$TO_FETCH_BRANCH" ]; then
        MSG=$(git pull)
      else
        MSG=$(git fetch origin "$TO_FETCH_BRANCH":"$TO_FETCH_BRANCH")
      fi

      if [[ $MSG =~ .*fatal* ]]; then
        echo -e "${RED}failed to fetch ${NO_COLOR}" # -e to skip ' in color names
        FAILED+=($REPO_SHORT)
      else
        echo -e "${GREEN}Successfully updated${NO_COLOR}"
      fi
    else
      echo -e "${YELLOW}Skipping because it doesn't look like it has a .git folder.${NO_COLOR}"
      SKIP+=($REPO_SHORT)
    fi
  else
    echo -e "${YELLOW}$(echo $REPO | rev | cut -d'/' -f-1 | rev) is not a directory${NO_COLOR}"
  fi
done

echo "$NEW_LINE ######## ~ Update complete ~ ######## $NEW_LINE"
if [[ ${#SKIP[*]} != 0 ]]; then
    echo -e "${YELLOW}Skipped Repos:${NO_COLOR}"
    echo "${SKIP[*]}"
fi

if [[ ${#FAILED[*]} != 0 ]]; then
    echo -e "${RED}Failed to fetch Repos: ${NO_COLOR}"
    echo "${FAILED[*]}"
fi

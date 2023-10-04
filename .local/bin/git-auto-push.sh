#!/bin/bash

# Color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Check if a commit message is provided as the first argument
if [ -z "$1" ]; then
  echo -e "${RED}Error: Please provide a commit message as the first argument.${RESET}"
  exit 1
fi

# Check if there are changes in the remote repository
if [ -n "$(git remote show origin -n | grep 'out of date')" ]; then
  echo -e "${GREEN}Pulling from the remote repository...${RESET}"
  git pull
else
  echo -e "${GREEN}No changes in the remote repository.${RESET}"
fi

# Perform Git operations
echo -e "${GREEN}Adding all changes...${RESET}"
git add .

echo -e "${GREEN}Committing changes with message: $1${RESET}"
git commit -m "$1"

echo -e "${GREEN}Pushing to the remote repository...${RESET}"
git push

echo -e "${GREEN}Git operations completed.${RESET}"

#!/bin/bash

history_word() {
  read -p "[~] Type the word your would like to remove : " n;
  sed -i "/$n/d" $HOME/.zsh_history
  clear
  echo -e "\n[✔] Done, Cleared word containing $n from history \n"
  echo "$n" >> cleared-history.txt
  history_word
}

history_word

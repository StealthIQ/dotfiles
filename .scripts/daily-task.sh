#!/bin/bash

# Time
time_hr=$(date +"%H")

# Tasks
tasks=$(cat $HOME/.scripts/tasks.txt)
# tasks=$(cat $HOME/MEGAsync/Todo/todo.txt | tail -1 | cut -b 5-15)

# Remainder - Task 1
drink_water() {
    notify-send -r 1 -i /usr/share/icons/kora/apps/scalable/waterfox-icon.svg "Time To Drink Water - [ Task 1 ]" 
}

# Remainder - Task 2
take_rest() {
    notify-send -r 1 -i /usr/share/icons/kora/apps/scalable/pomodoneapp.svg "Time To Take 1m Break - [ Task 2 ]" "Black Screen in 10s - 2mins Break"; 
    sleep 10
    feh $HOME/Pictures/Blackwall/black-solid &
    stopwatch &
    sleep 2m;
    killall feh
    pkill -9 -e -f stopwatch
    notify-send -r 1 -i /usr/share/icons/kora/status/scalable/trophy-gold.svg "Break Complete - [ Task 2 Done]" ; 
}

# Remainder - Task 3
do_meditation() {
    notify-send -r 1 -i /usr/share/icons/kora/apps/scalable/4kslideshowmaker.svg  "Time To Meditate - [ Task 3 ]" "Black Screen in 10s - 5mins Meditation";
    sleep 10
    feh $HOME/Pictures/Blackwall/black-solid &
    stopwatch &
    sleep 5m;
    killall feh
    pkill -9 -e -f stopwatch
    notify-send -r 1 -i /usr/share/icons/kora/status/scalable/trophy-gold.svg "Meditation Complete - [ Task 3 ]" ; 
}

# Remainder - Task 4

# Remainder - Task 5

# Remainder - Task 6

# Remainder - Task 7

# Remainder - Task 8

# Remainder - Task 9

# Remainder - Task 10


if [[ $1 = "--start" ]]; then
for (( ; ; ));
do
  # drink_water
  echo "$tasks"
  sleep 15m
  # take_rest
  # sleep 5
  if [[ $time_hr == "23" ]]; then
      # do_meditation
      echo "Nice"
  fi
done
else
  echo "--start - to start the script"
fi
  

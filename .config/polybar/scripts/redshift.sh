#!/bin/bash

envFile=~/.config/polybar/scripts/redshift.conf
changeValue=1000

# Function to read the config file and set REDSHIFT and REDSHIFT_TEMP variables
readConfig() {
  source "$envFile"
}

# Function to save the config to the file
saveConfig() {
  echo "REDSHIFT=$REDSHIFT" > "$envFile"
  echo "REDSHIFT_TEMP=$REDSHIFT_TEMP" >> "$envFile"
}

# Function to change REDSHIFT mode and update config file
changeMode() {
  readConfig
  REDSHIFT=$1
  saveConfig
}

# Function to change REDSHIFT temperature and update config file
changeTemp() {
  readConfig
  local new_temp=$((REDSHIFT_TEMP + changeValue))
  if [ "$new_temp" -gt 1000 ] && [ "$new_temp" -lt 25000 ]; then
    REDSHIFT_TEMP=$new_temp
    saveConfig
    redshift -P -O "$new_temp"
  fi
}

# Read the config file at the beginning
readConfig

case $1 in
  toggle)
    if [ "$REDSHIFT" = "on" ]; then
      changeMode "off"
      redshift -x
    else
      changeMode "on"
      redshift -O "$REDSHIFT_TEMP"
    fi
    ;;
  increase)
    changeTemp
    ;;
  decrease)
    local new_temp
    new_temp=$((REDSHIFT_TEMP - changeValue))
    if [ "$new_temp" -gt 1000 ] && [ "$new_temp" -lt 25000 ]; then
      REDSHIFT_TEMP=$new_temp
      saveConfig
      redshift -P -O "$new_temp"
    fi
    ;;
  temperature)
    case $REDSHIFT in
      on)
        printf "%dK" "$REDSHIFT_TEMP"
        ;;
      off)
        printf "off"
        ;;
    esac
    ;;
esac

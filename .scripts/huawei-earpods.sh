#! /bin/bash
hw_mac="88:81:B9:2A:7F:AA"
hp_sink="bluez_sink.88_81_B9_2A_7F_AA.handsfree_head_unit"

# Script for bluetooth auto-connect
bluetoothctl power on
bluetoothctl connect $hw_mac
pactl set-default-sink $hw_sink

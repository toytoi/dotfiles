#!/bin/bash

status=$(playerctl --player=tauon status 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    # Show pause icon when playing
    echo "%{T1}X%{T-}"  ; Pause 
elif [[ "$status" == "Paused" ]]; then
    # Show play icon when paused
    echo "%{T1}O%{T-}"  ; Play 
fi

# Output nothing if stopped or no player

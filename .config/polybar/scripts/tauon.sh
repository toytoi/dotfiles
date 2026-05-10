#!/bin/bash

# Fetch metadata from TauonMB via playerctl
artist=$(playerctl --player=tauon metadata artist 2>/dev/null)
title=$(playerctl --player=tauon metadata title 2>/dev/null)

# --- FIX START: Handle position as an integer in seconds ---
# 1. Fetch position (may be float or microsec)
raw_position=$(playerctl --player=tauon position 2>/dev/null)

# 2. Convert raw_position to a safe integer in seconds.
# We use 'cut -d. -f1' to strip the decimal part if it's a float (e.g., 5.45 -> 5).
# We use ${raw_position:-0} for null safety.
position=$(echo "${raw_position:-0}" | cut -d. -f1)

# The error token "5450694" suggests your player might be returning position in microseconds (like duration).
# If that's the case, uncomment the line below instead of the 'cut' line:
# position=$(( ${raw_position:-0} / 1000000 )) 

# --- FIX END ---

duration=$(playerctl --player=tauon metadata mpris:length 2>/dev/null)  # Total in microseconds
status=$(playerctl --player=tauon status 2>/dev/null)

# Exit early if the player is not actively playing or paused
if [[ "$status" != "Playing" && "$status" != "Paused" ]]; then
    exit 0
fi

# Convert duration to seconds, safely defaulting to 0
duration_seconds=$(( ${duration:-0} / 1000000 ))

# Function to format seconds as MM:SS
format_time() {
    local seconds=$1
    # The variables used here ($seconds) are now guaranteed to be integers.
    local minutes=$((seconds / 60))
    local secs=$((seconds % 60))
    printf "%d:%02d" "$minutes" "$secs"
}

# Only output if playing or paused
if [[ -n "$artist" && -n "$title" ]]; then
    if [[ $duration_seconds -gt 0 ]]; then
        # Include time: e.g., "Artist - Title [1:23 / 3:45]"
        echo "$artist - $title $(format_time "$position")/$(format_time "$duration_seconds")"
    else
        # Fallback without time if duration unavailable
        echo "$artist - $title"
    fi
elif [[ -n "$title" ]]; then
    echo "$title"  # Fallback to title only
fi

#!/bin/bash

# Define the commands and the Polybar hook for instant update
POLYBAR_HOOK="polybar-msg hook tauon 1"

# --- Rofi Options ---
# Use the new custom Rasi file
ROFI_CONFIG_FILE="~/.config/rofi/tauon.rasi"
ROFI_FONT="Symbols Nerd Font 12" # Use the font from your powermenu script

# --- Player Commands (Same as before) ---
PLAY_PAUSE="playerctl --player=tauon play-pause"
PREVIOUS="playerctl --player=tauon previous"
NEXT="playerctl --player=tauon next"
SHUFFLE="playerctl --player=tauon shuffle toggle"
LOOP="playerctl --player=tauon loop toggle"

# --- System Commands ---
VOL_UP="pactl set-sink-volume @DEFAULT_SINK@ +5%"
VOL_DOWN="pactl set-sink-volume @DEFAULT_SINK@ -5%"
PAVUCONTROL="pavucontrol"


# --- Check Status for Menu Labels ---
STATUS=$(playerctl --player=tauon status 2>/dev/null)
SHUFFLE_STATE=$(playerctl --player=tauon shuffle 2>/dev/null)
LOOP_STATE=$(playerctl --player=tauon loop 2>/dev/null)

if [[ "$STATUS" == "Playing" ]]; then
    PLAY_PAUSE_OPTION=" Pause"
else
    PLAY_PAUSE_OPTION=" Play"
fi
SHUFFLE_OPTION=" Shuffle (${SHUFFLE_STATE})"
LOOP_OPTION="repeat Loop (${LOOP_STATE})"

# --- Define the Menu Options (Emojis/Nerd Fonts) ---
MENU_OPTIONS="${PLAY_PAUSE_OPTION}
ﭣ Previous
ﭡ Next
${SHUFFLE_OPTION}
${LOOP_OPTION}
墳 Volume Up (+5%)
奄 Volume Down (-5%)
 Open Mixer (Pavucontrol)"

# --- Launch Rofi ---
CHOICE=$(echo -e "${MENU_OPTIONS}" | rofi -dmenu \
    -i \
    -p "Tauon" \
    -config "$ROFI_CONFIG_FILE" \
    -font "$ROFI_FONT" \
    -l 8 \
    -width 250)

# --- Execute Choice ---
case "$CHOICE" in
    *Play|*Pause)
        $PLAY_PAUSE
        ;;
    *Previous)
        $PREVIOUS
        ;;
    *Next)
        $NEXT
        ;;
    *Shuffle*)
        $SHUFFLE
        ;;
    *Loop*)
        $LOOP
        ;;
    *Volume Up*)
        $VOL_UP
        # Also hook the pulseaudio module for instant update
        polybar-msg hook pulseaudio 1
        ;;
    *Volume Down*)
        $VOL_DOWN
        polybar-msg hook pulseaudio 1
        ;;
    *Open Mixer*)
        $PAVUCONTROL &
        ;;
esac

# Force Polybar Tauon update after action
$POLYBAR_HOOK

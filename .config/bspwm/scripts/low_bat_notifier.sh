#!/bin/bash

### VARIABLES (Make configurable via env)
POLL_INTERVAL=${LOW_BAT_POLL:-240}  # seconds; override with env var
LOW_BAT=${LOW_BAT_THRESHOLD:-30}    # % low threshold
CRIT_BAT=${CRIT_BAT_THRESHOLD:-5}   # % critical (new: hibernate/lock)
NOTIF_MAX=${NOTIF_MAX:-3}           # Max notifications

BAT_PATH=/sys/class/power_supply/BAT0
BAT_STAT=$BAT_PATH/status

# Detect full/now paths
if [[ -f $BAT_PATH/charge_full ]]; then
    BAT_FULL=$BAT_PATH/charge_full
    BAT_NOW=$BAT_PATH/charge_now
elif [[ -f $BAT_PATH/energy_full ]]; then
    BAT_FULL=$BAT_PATH/energy_full
    BAT_NOW=$BAT_PATH/energy_now
else
    echo "No battery full/now files found at $BAT_PATH" >&2
    exit 1
fi

### FUNCTIONS
kill_running() {  # Stop older instances
    local mypid=$$
    declare -a pids=($(pgrep -f "${0##*/}"))
    for pid in "${pids[@]/$mypid}"; do  # Use array for safety
        kill "$pid" 2>/dev/null
        sleep 1
    done
}

notify_low() {
    local percent=$1
    local urgency="critical"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    notify-send --urgency="$urgency" "Low Battery: ${percent}%" \
        "Battery low! Charge soon. (Last warned: $timestamp)" \
        --hint=string:sound-name:"suspend-error"  # Optional: Play sound if dunst configured
}

critical_action() {
    local percent=$1
    notify-send --urgency="critical" "CRITICAL Battery: ${percent}%" \
        "Hibernate imminent! Saving state..." \
        --hint=int:transient:1  # Auto-dismiss after action
    # Lock + hibernate (adjust for your setup; requires polkit)
    loginctl lock-session  # Or xdg-screensaver lock
    sleep 10
    systemctl hibernate  # Fallback: shutdown -h now
}

### MAIN LOOP
launched=0
kill_running

# Run only if battery detected
if ls -1qA /sys/class/power_supply/ | grep -q '^BAT'; then
    while true; do
        # Safe reads with defaults
        if ! bf=$(cat "$BAT_FULL" 2>/dev/null); then
            echo "Failed to read $BAT_FULL" >&2
            sleep $POLL_INTERVAL
            continue
        fi
        if ! bn=$(cat "$BAT_NOW" 2>/dev/null); then
            echo "Failed to read $BAT_NOW" >&2
            sleep $POLL_INTERVAL
            continue
        fi
        bs=$(cat "$BAT_STAT" 2>/dev/null || echo "Unknown")

        # Use bc for precise math (install if needed: sudo pacman -S bc)
        bat_percent=$(echo "scale=0; 100 * $bn / $bf" | bc -l 2>/dev/null || echo 0)

        if [[ "$bs" = "Discharging" ]]; then
            if [[ $bat_percent -lt $CRIT_BAT ]]; then
                critical_action "$bat_percent"
                exit 0  # Exit after critical action
            elif [[ $bat_percent -lt $LOW_BAT && $launched -lt $NOTIF_MAX ]]; then
                notify_low "$bat_percent"
                launched=$((launched + 1))
            fi
        elif [[ "$bs" = "Charging" || "$bs" = "Full" ]]; then
            launched=0  # Reset on charge/full
        fi

        sleep $POLL_INTERVAL
    done
else
    echo "No battery detected" >&2
    exit 1
fi

#!/bin/bash
# Kill any hung Mullvad processes first
pkill -f mullvadbrowser.real 2>/dev/null
sleep 1  

# Launch with double-detach (setsid + --detach)
cd /opt/mullvad-browser
exec setsid --fork ./start-mullvad-browser --detach >/dev/null 2>&1

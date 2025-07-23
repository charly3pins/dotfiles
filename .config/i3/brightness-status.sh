# #!/bin/bash
# device="intel_backlight"
# while true; do
#     IFS=',' read -r _ _ current _ max <<< $(brightnessctl -d "$device" -m)
#     if [ -n "$max" ] && [ "$max" -gt 0 ] && [ -n "$current" ]; then
#         percent=$(( (current * 100) / max ))
#         echo "$percent%"
#     else
#         echo "N/A"
#     fi
#     sleep 1
# done

#!/bin/bash
device="intel_backlight"
pidfile="/tmp/brightness-status.pid"
while true; do
    IFS=',' read -r _ _ current _ max <<< $(brightnessctl -d "$device" -m)
    if [ -n "$max" ] && [ "$max" -gt 0 ] && [ -n "$current" ]; then
        percent=$(( (current * 100) / max ))
        echo "$percent%" > "$pidfile"
    else
        echo "N/A" > "$pidfile"
    fi
    sleep 1
done

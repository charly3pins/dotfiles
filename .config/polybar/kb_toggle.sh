#!/bin/bash
CURRENT=$(setxkbmap -query | grep layout | awk '{print $2}')
NEW="pt"
[[ "$CURRENT" == "pt" ]] && NEW="es"

for id in $(xinput list | grep -i 'DuckyChannel.*Keyboard' | grep -v 'System\|Consumer' | grep -o 'id=[0-9]*' | cut -d= -f2); do
    setxkbmap -device $id $NEW
done

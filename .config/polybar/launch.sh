#!/bin/bash
pkill polybar
sleep 1
if xrandr | grep -q "HDMI-1 connected"; then
  MONITOR=eDP-1 polybar c3p &
  MONITOR=HDMI-1 polybar c3p &
else
  MONITOR=eDP-1 polybar c3p &
fi

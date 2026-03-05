#!/usr/bin/env bash

pkill -x waybar
while pgrep -x waybar >/dev/null; do sleep 0.1; done
nohup waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/one-dark.css" >/dev/null 2>&1 &



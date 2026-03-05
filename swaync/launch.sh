#!/usr/bin/env bash

pkill -x swaync
while pgrep -x swaync >/dev/null; do sleep 0.1; done
nohup swaync >/dev/null 2>&1 &

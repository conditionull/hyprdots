#!/bin/sh

SINK_OUT=$(pactl list sinks | awk -v RS='' '/GameSink/' | awk -F'"' '/object.serial/ {print $2}')
SINK_IN=$(pactl list sink-inputs | awk -v RS='' '/Pogostuck.exe/' | awk -F'"' '/object.serial/ {print $2}')
CURRENT_SINK=$(pactl list sink-inputs | awk -v RS='' '/Pogostuck.exe/' | awk -F': ' '/Sink: / {print $2}')

if [ -z "$SINK_IN" ]; then
  notify-send "No Pogostuck sink input found"
  exit 1
fi

if [ "$CURRENT_SINK" = "$SINK_OUT" ]; then
  notify-send "Already on GameSink"
  exit 0
fi

if pactl move-sink-input "$SINK_IN" GameSink; then
  notify-send "Moved to GameSink"
else
  notify-send "Failed to move sink"
fi


#!/usr/bin/env bash

set -euo pipefail

WALL_DIR="$HOME/Pictures/Wallpapers"

mkdir -p "$WALL_DIR"

gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Blurification' 'Select a wallpaper for blur application!'

# Pick image from wallpaper folder
IMAGE_NAME="$(
  find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
    -printf '%f\n' |
  sort |
  gum filter \
    --height 15 \
    --placeholder "Pick a wallpaper..."
)"

if [[ -z "${IMAGE_NAME:-}" ]]; then
  notify-send "Blur wallpaper" "No wallpaper selected."
  exit 1
fi

# Pick blur strength
BLUR="$(
  gum choose \
    "2 smol" \
    "4  subtle" \
    "8  normal" \
    "12 strong" \
    "16 very strong" \
    "24 extreme" |
  awk '{print $1}'
)"

if [[ -z "${BLUR:-}" ]]; then
  notify-send "Blur wallpaper" "No blur strength selected."
  exit 1
fi

IN="$WALL_DIR/$IMAGE_NAME"

BASE="$(basename "$IN")"
NAME="${BASE%.*}"
EXT="${BASE##*.}"

OUT="$WALL_DIR/${NAME}_blurredx${BLUR}.${EXT}"

if [[ -e "$OUT" ]]; then
  gum confirm "Overwrite existing $(basename "$OUT")?" || exit 0
fi

gum spin \
  --spinner dot \
  --title "Creating blurred wallpaper..." \
  -- magick "$IN" -blur "0x${BLUR}" "$OUT"

notify-send "Blur wallpaper" "Saved: $(basename "$OUT")"

gum style \
  --border rounded \
  --padding "1 2" \
  --margin "1" \
  "Saved: $(basename "$OUT")"

sleep 1


#!/bin/bash

# Output paths
RAW_IMG="/tmp/eww_raw.png"
BLURRED_IMG="$HOME/.config/eww/widgets/images/fake-blur-bg.png"

# Blur strength (higher = blurrier)
BLUR_STRENGTH="0x8"

# Take screenshot using grim
grim "$RAW_IMG"

# Apply blur using imagemagick
convert "$RAW_IMG" -blur $BLUR_STRENGTH "$BLURRED_IMG"

# Clean up (optional)
rm "$RAW_IMG"

echo "Generated blurred background at $(date)" >> ~/.cache/eww_blur.log
echo "[+] Blurred background image saved to: $BLURRED_IMG"

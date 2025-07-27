
#!/bin/bash

CONFIG_DIR="$HOME/.config/eww"

# Files created by the Aurora Dashboard repo
FILES_TO_REMOVE=(
  "$CONFIG_DIR/eww-dashboard.yuck"
  "$CONFIG_DIR/eww-dashboard.scss"
  "$CONFIG_DIR/toggle_dashboard.sh"
  "$CONFIG_DIR/widgets/dashboard.yuck"
  "$CONFIG_DIR/widgets/dashboard.scss"
)

# Remove specific files
echo "[Uninstall] Removing Aurora Dashboard files..."
for file in "${FILES_TO_REMOVE[@]}"; do
  if [ -e "$file" ]; then
    echo "[Uninstall] Deleting $file"
    rm -f "$file"
  else
    echo "[Uninstall] Skipping $file (not found)"
  fi
done

# Remove the include line from eww.yuck if it exists
MAIN_YUCK="$CONFIG_DIR/eww.yuck"
if [ -f "$MAIN_YUCK" ]; then
  echo "[Uninstall] Cleaning up eww.yuck"
  sed -i '/(include "\.\/eww-dashboard\.yuck")/d' "$MAIN_YUCK"
fi

# Remove the import line from eww.scss if it exists
MAIN_SCSS="$CONFIG_DIR/eww.scss"
if [ -f "$MAIN_SCSS" ]; then
  echo "[Uninstall] Cleaning up eww.scss"
  sed -i '/@import "\.\/eww-dashboard";/d' "$MAIN_SCSS"
fi

echo "[Uninstall] Done. Aurora Dashboard files and config references removed."

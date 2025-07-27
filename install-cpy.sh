
#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/eww"

# Dashboard buffers (you write these in your Git repo)
DASHBOARD_YUCK_SRC="$REPO_DIR/eww-dashboard.yuck"
DASHBOARD_SCSS_SRC="$REPO_DIR/eww-dashboard.scss"

DASHBOARD_YUCK_DEST="$CONFIG_DIR/eww-dashboard.yuck"
DASHBOARD_SCSS_DEST="$CONFIG_DIR/eww-dashboard.scss"

# User files to patch once
MAIN_YUCK="$CONFIG_DIR/eww.yuck"
MAIN_SCSS="$CONFIG_DIR/eww.scss"

# Toggle Script
SCRIPT_DEST="$CONFIG_DIR/toggle_dashboard.sh"
SCRIPT_SRC="$REPO_DIR/toggle_dashboard.sh"
# Widgets
WIDGETS_SRC_DIR="$REPO_DIR/widgets"
WIDGETS_DEST_DIR="$CONFIG_DIR/widgets"
# Helper Scripts
SCRIPTS_SRC_DIR="$REPO_DIR/eww/scripts"
SCRIPTS_DEST_DIR="$CONFIG_DIR/scripts"
echo "[Install] Installing Aurora Dashboard with file copies..."

mkdir -p "$CONFIG_DIR"

# --- Copy dashboard.yuck buffer ---
if [ -e "$DASHBOARD_YUCK_DEST" ]; then
  echo "[Install] Overwriting existing eww-dashboard.yuck"
  rm -f "$DASHBOARD_YUCK_DEST"
fi
cp "$DASHBOARD_YUCK_SRC" "$DASHBOARD_YUCK_DEST"

# --- Copy dashboard.scss buffer ---
if [ -e "$DASHBOARD_SCSS_DEST" ]; then
  echo "[Install] Overwriting existing eww-dashboard.scss"
  rm -f "$DASHBOARD_SCSS_DEST"
fi
cp "$DASHBOARD_SCSS_SRC" "$DASHBOARD_SCSS_DEST"

# --- Copy toggle script ---
if [ -e "$SCRIPT_DEST" ]; then
  echo "[Install] Overwriting existing toggle_dashboard.sh"
  rm -f "$SCRIPT_DEST"
fi
cp "$SCRIPT_SRC" "$SCRIPT_DEST"
chmod +x "$SCRIPT_DEST"

# --- Append once to main eww.yuck ---
if [ ! -f "$MAIN_YUCK" ]; then
  echo "[Install] Creating empty eww.yuck"
  touch "$MAIN_YUCK"
fi
if ! grep -qF "eww-dashboard.yuck" "$MAIN_YUCK"; then
  echo "[Install] Appending include to eww.yuck"
  echo '(include "./eww-dashboard.yuck")' >> "$MAIN_YUCK"
fi

# --- Append once to main eww.scss ---
if [ ! -f "$MAIN_SCSS" ]; then
  echo "[Install] Creating empty eww.scss"
  touch "$MAIN_SCSS"
fi
if ! grep -qF "eww-dashboard.scss" "$MAIN_SCSS"; then
  echo "[Install] Appending import to eww.scss"
  echo '@import "./eww-dashboard";' >> "$MAIN_SCSS"
fi

# --- Copy widget files (dashboard.yuck + dashboard.scss) ---
mkdir -p "$WIDGETS_DEST_DIR"

for widget_file in "dashboard.yuck" "dashboard.scss"; do
  src="$WIDGETS_SRC_DIR/$widget_file"
  dest="$WIDGETS_DEST_DIR/$widget_file"

  if [ -f "$src" ]; then
    echo "[Install] Copying widget file $widget_file"
    cp "$src" "$dest"
  else
    echo "[Install] WARNING: $widget_file not found in widgets/ directory!"
  fi
done

# --- Copy scripts from eww/scripts/ ---

mkdir -p "$SCRIPTS_DEST_DIR"

if [ -d "$SCRIPTS_SRC_DIR" ]; then
  echo "[Install] Copying helper scripts..."
  cp -r "$SCRIPTS_SRC_DIR/"* "$SCRIPTS_DEST_DIR/"

  # Make all scripts executable
  chmod +x "$SCRIPTS_DEST_DIR/"*
else
  echo "[Install] No scripts directory found at $SCRIPTS_SRC_DIR, skipping."
fi

echo "[Install] Aurora Dashboard installed using copies. Main configs only appended once."

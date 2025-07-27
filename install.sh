#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/eww"

# Buffer configs
DASHBOARD_YUCK_SRC="$REPO_DIR/eww-dashboard.yuck"
DASHBOARD_SCSS_SRC="$REPO_DIR/eww-dashboard.scss"
DASHBOARD_YUCK_LINK="$CONFIG_DIR/eww-dashboard.yuck"
DASHBOARD_SCSS_LINK="$CONFIG_DIR/eww-dashboard.scss"

# Main Eww config
MAIN_YUCK="$CONFIG_DIR/eww.yuck"
MAIN_SCSS="$CONFIG_DIR/eww.scss"

# Toggle script
SCRIPT_SRC="$REPO_DIR/toggle_dashboard.sh"
SCRIPT_LINK="$CONFIG_DIR/toggle_dashboard.sh"

# Widget files
WIDGET_YUCK_SRC="$REPO_DIR/widgets/dashboard.yuck"
WIDGET_YUCK_DEST="$CONFIG_DIR/widgets/dashboard.yuck"
WIDGET_SCSS_SRC="$REPO_DIR/widgets/dashboard.scss"
WIDGET_SCSS_DEST="$CONFIG_DIR/widgets/dashboard.scss"

WIDGET_SRC_DIR="$REPO_DIR/widgets"
WIDGET_DEST_DIR="$CONFIG_DIR/widgets"

# Helper scripts directory
SCRIPTS_SRC_DIR="$REPO_DIR/scripts"
SCRIPTS_DEST_DIR="$CONFIG_DIR/scripts"

# Images directory
IMAGES_SRC_DIR="$REPO_DIR/widgets/images"
IMAGES_DEST_DIR="$CONFIG_DIR/widgets/images"

# Icons directory
ICONS_SRC_DIR="$REPO_DIR/widgets/images/icons"
ICONS_DEST_DIR="$CONFIG_DIR/widgets/images/icons"

echo "[Install] Installing Aurora Dashboard..."

mkdir -p "$CONFIG_DIR/widgets"
mkdir -p "$SCRIPTS_DEST_DIR"

# --- Link buffer config files ---
for src in "$DASHBOARD_YUCK_SRC" "$DASHBOARD_SCSS_SRC"; do
    dest="$CONFIG_DIR/$(basename "$src")"
    if [ -L "$dest" ] || [ -e "$dest" ]; then
        echo "[Install] Overwriting $(basename "$dest")"
        rm -f "$dest"
    fi
    ln -s "$src" "$dest"
done

# --- Link widget files ---
# for src in "$WIDGET_YUCK_SRC" "$WIDGET_SCSS_SRC"; do
#     dest="$CONFIG_DIR/widgets/$(basename "$src")"
#     if [ -L "$dest" ] || [ -e "$dest" ]; then
#         echo "[Install] Overwriting $(basename "$dest")"
#         rm -f "$dest"
#     fi
#     ln -s "$src" "$dest"
#     echo "[Install] linked $(basename "$dest")"
# done
#
if [ -d "$WIDGET_SRC_DIR" ]; then
    for src in "$WIDGET_SRC_DIR"/*; do
        [ -f "$src" ] || continue
        dest="$WIDGET_DEST_DIR/$(basename "$src")"
        if [ -L "$dest" ] || [ -e "$dest" ]; then
            echo "[Install] Overwriting file $(basename "$dest")"
            rm -f "$dest"
        fi
        ln -s "$src" "$dest"
        echo "[Install] linked file $(basename "$dest")"
    done
fi
# --- Link helper script files (individually like widget files) ---
if [ -d "$SCRIPTS_SRC_DIR" ]; then
    for src in "$SCRIPTS_SRC_DIR"/*; do
        [ -f "$src" ] || continue
        dest="$SCRIPTS_DEST_DIR/$(basename "$src")"
        if [ -L "$dest" ] || [ -e "$dest" ]; then
            echo "[Install] Overwriting script $(basename "$dest")"
            rm -f "$dest"
        fi
        ln -s "$src" "$dest"
        chmod +x "$dest"
        echo "[Install] linked script $(basename "$dest")"
    done
fi

if [ -d "$IMAGES_SRC_DIR" ]; then
    for src in "$IMAGES_SRC_DIR"/*; do
        [ -f "$src" ] || continue
        dest="$IMAGES_DEST_DIR/$(basename "$src")"
        if [ -L "$dest" ] || [ -e "$dest" ]; then
            echo "[Install] Overwriting file $(basename "$dest")"
            rm -f "$dest"
        fi
        ln -s "$src" "$dest"
        echo "[Install] linked Image $(basename "$dest")"
    done
fi

if [ -d "$ICONS_SRC_DIR" ]; then
    for src in "$ICONS_SRC_DIR"/*; do
        [ -f "$src" ] || continue
        dest="$ICONS_DEST_DIR/$(basename "$src")"
        if [ -L "$dest" ] || [ -e "$dest" ]; then
            echo "[Install] Overwriting Icon file $(basename "$dest")"
            rm -f "$dest"
        fi
        ln -s "$src" "$dest"
        echo "[Install] Icon file $(basename "$dest")"
    done
fi
# --- Link toggle script ---
if [ -L "$SCRIPT_LINK" ] || [ -e "$SCRIPT_LINK" ]; then
    echo "[Install] Overwriting toggle_dashboard.sh"
    rm -f "$SCRIPT_LINK"
fi
ln -s "$SCRIPT_SRC" "$SCRIPT_LINK"
chmod +x "$SCRIPT_LINK"

# --- Append buffer includes to main configs ---
if [ ! -f "$MAIN_YUCK" ]; then
    echo "[Install] Creating empty eww.yuck"
    touch "$MAIN_YUCK"
fi
if ! grep -qF "eww-dashboard.yuck" "$MAIN_YUCK"; then
    echo "[Install] Appending include to eww.yuck"
    echo '(include "./eww-dashboard.yuck")' >> "$MAIN_YUCK"
fi

if [ ! -f "$MAIN_SCSS" ]; then
    echo "[Install] Creating empty eww.scss"
    touch "$MAIN_SCSS"
fi
if ! grep -qF "eww-dashboard.scss" "$MAIN_SCSS"; then
    echo "[Install] Appending import to eww.scss"
    echo '@import "./eww-dashboard";' >> "$MAIN_SCSS"
fi

echo "[Install] Aurora Dashboard installed and linked. Main configs only appended once."

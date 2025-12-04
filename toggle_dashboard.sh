#!/bin/bash

DASHBOARD_WIDGET="dashboard"
DASHBOARD_WS=99
AUR_PACKAGES=(eww)
PACMAN_PACKAGES=(waybar pacman-contrib)

CFG="$HOME/.config/eww"
EWW=`which eww`
# Function to check if a package is installed
is_installed() {
  pacman -Q "$1" &>/dev/null
}

# Check for yay
if ! command -v yay &>/dev/null; then
  echo "[Dashboard Toggle] AUR helper 'yay' not found."

  read -rp "Do you want to install 'yay' manually now? [y/N] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "1. git clone https://aur.archlinux.org/yay.git"
    echo "2. cd yay && makepkg -si"
    echo "3. Re-run this script after installation."
    exit 1
  else
    echo "Cannot install AUR packages without 'yay'. Exiting."
    exit 1
  fi
fi

# Install missing packages
for pkg in "${PACMAN_PACKAGES[@]}"; do
  if ! is_installed "$pkg"; then
    echo "[Dashboard Toggle] Missing package: $pkg"
    read -rp "Install '$pkg' via pacman? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] && sudo pacman -S "$pkg" || exit 1
  fi
done

for pkg in "${AUR_PACKAGES[@]}"; do
  if ! is_installed "$pkg"; then
    echo "[Dashboard Toggle] Missing AUR package: $pkg"
    read -rp "Install '$pkg' via yay? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] && yay -S "$pkg" || exit 1
  fi
done



## Open widgets 
run_eww() {
	${EWW} --config "$CFG" open-many \
		   background \
		   profile \
		   system \
           status \
		   clock \
		   uptime \
		   music \
		   github \
		   reddit \
		   twitter \
		   youtube \
		   todo-list \
		   apps \
		   mail \
		   logout \
		   sleep \
		   reboot \
		   poweroff \
		   folders
}


## Close widgets 
stop-eww() {
	${EWW} --config "$CFG" close-many \
		   background \
		   profile \
		   system \
           status \
		   clock \
		   uptime \
		   music \
		   github \
		   reddit \
		   twitter \
		   youtube \
		   todo-list \
		   apps \
		   mail \
		   logout \
		   sleep \
		   reboot \
		   poweroff \
		   folders
}


# Toggle logic
if pgrep -x "eww" > /dev/null && eww list-windows | grep -q "uptime"; then
  notify-send "hyprArch Dashboard" "Closing dashboard..."
  echo "[Dashboard Toggle] Closing dashboard"

  # eww close "$DASHBOARD_WIDGET"
  stop_eww
  sleep 0.1
  killall eww 2>/dev/null

  echo "[Dashboard Toggle] Switching to workspace 1"
  hyprctl dispatch workspace 1

  if ! pgrep -x "waybar" > /dev/null; then
    echo "[Dashboard Toggle] Starting Waybar..."
    "$HOME/.config/waybar/launch.sh"
  fi

else
  notify-send "Aurora Dashboard" "Opening dashboard..."
  echo "[Dashboard Toggle] Opening dashboard"

  echo "[Dashboard Toggle] Switching to dashboard workspace $DASHBOARD_WS"
  hyprctl dispatch workspace "$DASHBOARD_WS"
  sleep 0.15

  if pgrep -x "waybar" > /dev/null; then
    echo "[Dashboard Toggle] Stopping Waybar..."
    killall waybar
    sleep 0.1
  fi

  eww daemon
  sleep 0.1
  # eww open "$DASHBOARD_WIDGET"
  run_eww
fi

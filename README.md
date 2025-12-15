# hyprArch Dashboard
> ⚠️ This Repo is still under development and is incomplete!
A custom Hyprland dashboard built using Eww, Bash, and Wayland tools.  
Displays system metrics, Git status, calendar, to-do list, and music controls.

## Structure

- `widgets/`: Eww `.yuck` and `.scss` files
- `scripts/`: Shell scripts for dynamic content
- `toggle_dashboard.sh`: Script to toggle dashboard/workbench view


## Installation

To install, run the `install.sh` script. If you encounter symlink issues, please uninstall all components and use the `install-cpy.sh` script instead.


## Usage 
Execute the `toggle_dashboard.sh` script directly or assign the command `./toggle_dashboard.sh` to a keyboard shortcut, such as `SUPER+G`.

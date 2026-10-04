# Start Hyprland when logging in on tty1 (autologin: arch/system/getty-autologin.conf).
# Not exec'd on purpose: if Hyprland fails to start or you exit it, you land in
# a shell on tty1 instead of an autologin + crash loop. Other TTYs work as usual.
if [[ -z $WAYLAND_DISPLAY && $XDG_VTNR -eq 1 ]]; then
  start-hyprland
fi

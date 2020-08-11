if [[ "$(tty)" = "/dev/tty1" ]]; then
		pgrep xmonad || startx
fi

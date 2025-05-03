# Add .local/bin to end of PATH for local binaries
export PATH=$HOME/.local/bin:$PATH

# Load profiles from .profile.d
if test -d $HOME/.profile.d/; then
	for profile in $HOME/.profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Set theme (GTK4 Workaround)
export GTK_THEME=WhiteSur-Dark-solid-blue-nord #Flat-Remix-GTK-Blue-Dark-Solid

PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')

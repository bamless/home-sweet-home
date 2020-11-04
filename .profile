# Add .local/bin to end of PATH for local binaries
export PATH=$PATH:$HOME/.local/bin

# Load profiles from .profile.d
if test -d $HOME/.profile.d/; then
	for profile in $HOME/.profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi


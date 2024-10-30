# Add .local/bin to end of PATH for local binaries
export PATH=$HOME/.local/bin:$PATH

# Load profiles from .profile.d
if test -d $HOME/.profile.d/; then
	for profile in $HOME/.profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Colorize man pages 
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking 
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold 
export LESS_TERMCAP_me=$'\E[0m'           # end mode 
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode 
export LESS_TERMCAP_so=$'\E[7m'           # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline 
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underlin

# Set theme (GTK4 Workaround)
export GTK_THEME=WhiteSur-Dark-solid-blue-nord #Flat-Remix-GTK-Blue-Dark-Solid

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')

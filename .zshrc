# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Env variables.
export EDITOR='nvim'
export PAGER='less'
export ZSH="/home/$USER/.oh-my-zsh"

# Zsh Plugins.
plugins=(git zsh-autosuggestions vi-mode)
MODE_INDICATOR="%F{yellow}(N) %f"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="afowler"

# Zsh auto-suggest  strategy
ZSH_AUTOSUGGEST_STRATEGY=(history)

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Init oh-my-zsh
source $ZSH/oh-my-zsh.sh

RPS1="\$(vi_mode_prompt_info)$RPS1"

# Scroll thorugh history taking into account currently typed text
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Aliases.
alias vim="nvim"
alias ls="eza"


# Enable gnome-keyring for i3 and Hyprland
if [[ "${XDG_CURRENT_DESKTOP}" == "i3" ]]; then
    eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh 2>/dev/null)
fi
if [[ "${XDG_CURRENT_DESKTOP}" == "Hyprland" ]]; then
    eval "export $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh 2>/dev/null)"
fi
# GDM does not source this on login on wayland, do it here :(
if [[ "${XDG_BACKEND}" == "wayland" && -v "GDMSESSION" ]]; then
    source ~/.zprofile
fi

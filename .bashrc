#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Aliases
alias update-mirrors="reflector --verbose -c Italy -a 6 --sort rate --save /etc/pacman.d/mirrorlist"
alias code="code --ignore-gpu-blacklist --enable-gpu-rasterization --enable-oop-rasterization --enable-native-gpu-memory-buffers --no-sandbox --unity-launch"

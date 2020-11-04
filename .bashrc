#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Aliases
alias update-mirrors="sudo reflector --verbose -c Germany -c Italy -c Netherlands --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
alias code="code --ignore-gpu-blacklist --enable-gpu-rasterization --enable-oop-rasterization --no-sandbox --unity-launch"

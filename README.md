# `~` sweet `~`

This is my personal collection of configuration files (*dotfiles*) and scripts. Nothing too special, just a couple of files that help me keep in sync user settings on my various machines.  
Keep in mind that these are tailored to my personal taste and needs and they may set up things in ways that aren't cosidered standard (or even sensible by some), so use at your own risk.  
In the following I'll give an overview on how the repository is structured, mostly as documentation for my future self.

## Repository structure

### .config
This folder contains configuration files of various applications and sytem settings.

### .dconf_dump
Settings of apps that use dconf to store their configurations, such as gnome-terminal.  
Restore them with `dconf load /dconf/app/path < conf-file.dconf`.

### .local
In this folder I try to mirror the Linux File System Hierarchy for installing user-specific software and libraries. The `PATH` environment variable is also extended with `.local/bin` in order to allow execution of local binaries from the shell. Some utiliy scripts are also included in it.

### .pkglist
This folder contains Arch Linux packages lists. Speifically, `pkglist.txt` contains all installed packages from the official repository, while `aur-pkglist.txt` contains the ones installed from the AUR. To install all of the official packages this command can be used: `pacman -S --needed - < .pkglist/pkglist.txt`.

### .profile, .profile.d
This file and folder mirror how `/etc/profile` and `/etc/profile.d` are used to set environment variables. `.profile` gets executed on login shells or desktop environment initialization, and it runs all the scripts in `.profile.d`. These scripts in turn set environment variables needed for applications.

### .zshrc/.zprofile, .bashrc/.bash_profile
Zsh and Bash configuration files. `.zprofile` and `.bash_profile` are simply set up to source `.profile` and kickstart the environment initialization process. `.bashrc` is a farly barebone bash configuration file, left here only for compatibility. `.zshrc` instead contains all my personal shell settings and aliases, and it needs [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) with the [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) plugin installed to correctly function.

## File tracking
I use [dotfiles.sh](https://github.com/eli-schwartz/dotfiles.sh.git), a wrapper for git that allows tracking files directly in `$HOME` without initializing a repository in it. Instead, all git metadata are stored in `~/.home-sweet-home` keeping the home free of unnecessary files. 
Adding or removing a file works just like it would for a normal git repository:
```bash
dotfiles add .file
dotfiles commit -m 'Add .file'
dotfiles push
```

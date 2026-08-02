# `~` sweet `~`

This is my personal collection of configuration files, commonly known as
*dotfiles*, and utility scripts. There is nothing particularly special here;
these files simply help me keep my user environment consistent across my
machines.

They are tailored to my personal preferences and requirements and may configure
things in ways that are not considered standard - or even sensible - by everyone.
Use them at your own risk.

The following is an overview of the repository structure, written mostly as
documentation for my future self.

## Repository structure

### `.config`

Configuration files for applications and user-level system components, following
the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/).

This directory also contains `environment.d` configuration files used to define
environment variables for the systemd user environment.

### `.config/environment.d`

Declarative environment-variable configuration for the systemd user manager.

Files in this directory use `KEY=value` assignments, for example:

```ini
PATH=${HOME}/.local/bin:${HOME}/.cargo/bin:$PATH
EDITOR=nvim
```

Unlike shell startup files, these files are not shell scripts. They cannot run
commands or contain shell constructs such as aliases, functions, conditionals,
or command substitutions.

Changes normally take effect after logging out and back in. The environment
visible to the systemd user manager can be inspected with:

```bash
systemctl --user show-environment
```

### `.local`

User-specific executables, libraries, application data, and utility scripts.

The directory follows the conventional [Filesystem Hierarchy](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
where practical. In particular, `.local/bin` contains executables intended to 
be available through `PATH`.

### `.zshrc`

Configuration file for Zsh.

Contains my interactive Zsh configuration, including aliases, options,
and shell integrations. It requires
[Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and the
[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
plugin.

### `.tmux.conf`

Personal tmux configuration.

It requires the
[tmux plugin manager](https://github.com/tmux-plugins/tpm). After starting tmux
for the first time, press `<prefix> + I` to install the configured plugins.

## File tracking

I use [dotfiles.sh](https://github.com/eli-schwartz/dotfiles.sh), a Git wrapper
that allows files to be tracked directly from `$HOME` without creating a
`.git` directory there.

The repository metadata is instead stored in:

```text
~/.home-sweet-home
```

Files can then be managed similarly to a normal Git repository:

```bash
dotfiles add .file
dotfiles commit -m 'Add .file'
dotfiles push
```

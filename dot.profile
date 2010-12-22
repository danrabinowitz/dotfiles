# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# The default umask is set in /etc/profile
# On debian, for setting the umask for ssh logins, install and configure the libpam-umask package.
umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export EDITOR=mate

# Hmmm, where should aliases go?
alias ls="ls -FG"
alias rm="rm -i"

# use colors based on ~/.dircols
if [ -f ~/.dircols ]; then
        export DIRCOL=`dircolors -b ~/.dircols`
        export LS_COLORS=`echo $DIRCOL | cut -f2 -d"'"`
fi

# Sample shell function
# function work()
# {
#  cd ~/arena-build/work/$@
#}


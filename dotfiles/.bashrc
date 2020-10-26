# ~/.bashrc
# For notes about this file, and what goes in ~/.bash_profile versus ~/.profile versus ~/.bashrc see Bash_Dotfiles.txt

# IMPORTANT: This file MUST be clean with NO OUTPUT
# TODO: Add reference as to why this is

#############################################################################
# This file is designed to work on OS X and Debian

# TODO:
# Add tests?
# Speed test this?
# Find out how many times .profile is run versus .bashrc

# TODO: Consider this idea
# Create a temp file at the start of .bashrc, and delete it at the end.
# Check if it exists on starting .bashrc, and if it does then exit, assuming that there's a problem with .bashrc

# Not sure why yet, but this seems needed for app-shell01
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# if [ -f ~/.bashrc_local_non_interactive ]; then
#     . ~/.bashrc_local_non_interactive
# fi

if [ -f ~/.profile ]; then
  source ~/.profile
fi

# If not running interactively, don't do anything
# This "interactive" quality is distinct from the login/non-login shell (vis a vis .profile / .bashrc). It simply ensures that nothing is output for non-interactive shells.
# TODO: We need to be able to log something if DEBUG is set, even if non-interactive
[ -z "$PS1" ] && return

#echo "Start of .bashrc -- WARNING .bashrc MUST be clean with NO OUTPUT!"

# ----------------------------------------------------------------------
#  THE BASICS
# ----------------------------------------------------------------------

# : ${VAR:=val} is a shorthand way of setting VAR to val unless VAR is already set

: ${HOME:=~}                 # The home director of the logged-in user
: ${LOGNAME:=$(id -un)}      # This is the name of the logged-in user
: ${UNAME:=$(uname)}         # This is the name of the OS. TODO: Do we need this?

# readline config. This simply sets the default, so there is no point.
# : ${INPUTRC:=~/.inputrc}

if test -n "$SSHHOME" ; then
  echo "You are using sshrc ( https://github.com/Russell91/sshrc ). This message comes from .bashrc."
fi


# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

# Keep in .bashrc because it is only needed on interactive shells
# notify of bg job completion immediately
set -o notify

# Keep in .bashrc because it is only needed on interactive shells
# shell opts. see bash(1) for details
shopt -s cdspell >/dev/null 2>&1

# append to the history file, don't overwrite it
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
shopt -s histappend >/dev/null 2>&1

# On by default
# shopt -s interactive_comments >/dev/null 2>&1

# Huh. Let us try this with -s to turn it on. If it is annoying or unneeded, then set back to -u  -dan 12/15/1
shopt -s mailwarn >/dev/null 2>&1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#MAILCHECK=60

# ----------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac

# enable en_US locale w/ utf-8 encodings if not already configured
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL


# http://stackoverflow.com/a/19533853 aka http://stackoverflow.com/questions/9457233/unlimited-bash-history/19533853#19533853
#
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTTIMEFORMAT="%m/%d/%y %T "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
# PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# For security purposes, do not record history for root
if [ $EUID -eq 0 ] ; then
        unset HISTFILE
fi


# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

# export EDITOR='sbl -w'
export EDITOR=vim

# PAGER
if test -n "$(command -v less)" ; then
# Use "-R" per this post: http://playingwithsid.blogspot.com/2008/01/raw-control-characters-in-less-pager.html
    PAGER="less -FirSwXR"
    MANPAGER="less -FiRswX"
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# Ack
ACK_PAGER="$PAGER"

# Since we have set up $PAGER, make sure we USE it. I type less usually, so alias it to $PAGER
# Intentionally placed with the $PAGER code instead of the aliases
alias less="$PAGER"

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------
# NOTE: I am putting completion BEFORE prompt so that __git_ps1 gets defined before prompt

. ~/Config/bash/completion

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

. ~/Config/bash/prompt

# -------------------------------------------------------------------
# MOTD / FORTUNE
# -------------------------------------------------------------------

#test -n "$INTERACTIVE" -a -n "$LOGIN" && {
#    echo "FYI: .bashrc is reporting that this is an INTERACTIVE and LOGIN shell "
#    uname -npsr
#    uptime
#}


### End block

# Set aliases and variables for specific programs which are used from an INTERACTIVE bash session
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#export RUBYGEMS_GEMDEPS="-"


#if [ "$UNAME" = Darwin ]; then
#  LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
#  if [ -f $LUNCHY_DIR/lunchy-completion.bash ]; then
#    . $LUNCHY_DIR/lunchy-completion.bash
#  fi
#fi

# Load aliases. Depends on PAGER being set
# . ~/Config/bash/aliases
source ~/.profile_interactive

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

### Added by the Heroku Toolbelt
# export PATH="/usr/local/heroku/bin:$PATH"

# direnv must be near the very end.
# "Make sure it appears even after rvm, git-prompt and other shell extensions that manipulate the prompt."
eval "$(direnv hook bash)"

# TODO: Output to a log that .bashrc was run. Include the date, the PID, the PPID, etc.

# The following 3 lines, which must be near the END of the file, tell Emacs to use sh mode for this file
# Local Variables:
# mode: sh
# End:


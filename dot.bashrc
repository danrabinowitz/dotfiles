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


# TODO: DJR 12/22/10: Look into this.  Do I need/want it?
# don't put duplicate lines in the history. See bash(1) for more options
#export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=ignoreboth
export HISTFILESIZE=10000


# For security purposes, do not record history for root
if [ $EUID -eq 0 ] ; then
        unset HISTFILE
fi


# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

export EDITOR=emacs

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

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------
# we always pass these to ls(1)
#LS_COMMON="-hBFG"
LS_COMMON="-hF"

LS_COLOR=''

# if the dircolors utility is available, set that up to
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
#    LS_COLOR=' --color=auto'
    LS_COLOR='-G'
}
unset dircolors

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    LS_COLOR=' --color=auto'
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# setup the main ls alias
alias ls="command ls $LS_COMMON $LS_COLOR"

# these use the ls aliases above
alias ll="ls -l"
alias l.="ls -d .*"

# -------------------------------------------------------------------
# MOTD / FORTUNE
# -------------------------------------------------------------------

test -n "$INTERACTIVE" -a -n "$LOGIN" && {
    echo "FYI: .bashrc is reporting that this is an INTERACTIVE and LOGIN shell "
    uname -npsr
    uptime
}


### End block




# Set aliases and variables for specific programs which are used from an INTERACTIVE bash session
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# Load aliases. Depends on PAGER being set
. ~/Config/bash/aliases

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

# TODO: Output to a log that .bashrc was run. Include the date, the PID, the PPID, etc.

# The following 3 lines, which must be near the END of the file, tell Emacs to use sh mode for this file
# Local Variables:
# mode: sh
# End:

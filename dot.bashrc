# -*- mode: sh; -*-
# ~/.bashrc
# This file is designed to work on OS X and Debian

###############################################################################
# What should go where
#   Authoritative version in .bashrc
#
# Anything that should be available to graphical applications OR to sh (or bash invoked as sh) MUST be in ~/.profile
# Anything that should be available to non-login shells should be in ~/.bashrc.
#   ~/.bashrc must not output anything
#   Outstanding question: Should .bashrc source .profile? The other way around? Neither?
# Anything that should be available only to login shells should go in ~/.bash_profile
# Ensure that ~/.bash_login does not exist.

###############################################################################
# Sourcing other files
# ~/.bash_profile should source ~/.bashrc
# ~/.bash_profile should probably also source .profile since ~/.profile isn't run if ~/.bash_profile exists.
#   Outstanding question: Do we need to set a variable in .bashrc to make sure it isn't run twice, since it could be run from /etc/profile?

###############################################################################
# Justification for what should go where
# From the bash man page: For login shells, bash looks for ~/.bash_profile,
# ~/.bash_login, and ~/.profile, in that order, and reads and executes commands
# from the first one that exists and is readable.
#
# For non-login shells, only .bashrc is read.
#
# Sources
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
# http://linux.die.net/man/1/bash
# https://rvm.beginrescueend.com/support/faq/#shell_login
#
###############################################################################
# Tests

###############################################################################
# End of discussion
###############################################################################

source ~/Config/testing/logging.sh
log_with_bash_info "Start of .bashrc"

# If not running interactively, don't do anything
# This "interactive" quality is distinct from the login/non-login shell (vis a vis .profile / .bashrc). It simply ensures that nothing is output for non-interactive shells.
[ -z "$PS1" ] && return

#echo "Start of .bashrc -- WARNING .bashrc MUST be clean with NO OUTPUT!"

# ----------------------------------------------------------------------
#  THE BASICS
# ----------------------------------------------------------------------

# : ${VAR:=val} is a shorthand way of setting VAR to val unless VAR is already set

: ${HOME:=~}
: ${LOGNAME:=$(id -un)}
: ${UNAME:=$(uname)}

# complete hostnames from this file
: ${HOSTFILE:=~/.ssh/known_hosts}

# TODO: Do we want to do anything with this?
# readline config
: ${INPUTRC:=~/.inputrc}


# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
shopt -s cdspell >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1

# append to the history file, don't overwrite it
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
shopt -s histappend >/dev/null 2>&1

shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# fuck that you have new mail shit
# Update by Dan: I DO want to see this so I can handle it appropriately
#unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# The default umask is set in /etc/profile
# On debian, for setting the umask for ssh logins, install and configure the libpam-umask package.
# TODO: Can we check if debian and if libpam-umask is installed and warn if not?
# default umask
umask 0022

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# Include /opt/local/bin and sbin if they exist
if [ -d "/opt/local/bin" ] ; then
    PATH="$PATH:/opt/local/bin"
fi
if [ -d "/opt/local/sbin" ] ; then
    PATH="$PATH:/opt/local/sbin"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

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
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
export HISTFILESIZE=5500

# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

export EDITOR=mate

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

# Now that we have set up $PAGER, make sure we USE it. I type less usually, so alias it to $PAGER
alias less="$PAGER"

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

GREEN_FG_RED_BG="\[\033[0;32m\033[0;41m\]"
RED="\[\033[0;31m\]"
BROWN="\[\033[0;33m\]"
GREY="\[\033[0;97m\]"
BLUE="\[\033[0;34m\]"
PS_CLEAR="\[\033[0m\]"
SCREEN_ESC="\[\033k\033\134\]"

if [ "$LOGNAME" = "root" ]; then
    COLOR1="${RED}"
    COLOR2="${BROWN}"
    P="#"
elif hostname | grep -q 'github\.com'; then
    GITHUB=yep
    COLOR1="\[\e[0;94m\]"
    COLOR2="\[\e[0;92m\]"
    P="\$"
else
    COLOR1="${BLUE}"
    COLOR2="${BROWN}"
    P="\$"
fi

prompt_simple() {
    unset PROMPT_COMMAND
    PS1="[\u@\h:\w]\$ "
    PS2="> "
}

prompt_compact() {
    unset PROMPT_COMMAND
    PS1="${COLOR1}${P}${PS_CLEAR} "
    PS2="> "
}

prompt_color() {
    PS1="${GREY}[${COLOR1}\u${GREY}@${COLOR2}\h${GREY}:${COLOR1}\W${GREY}]${COLOR2}$P${PS_CLEAR} "
    PS2="\[;1m\]continue \[m\]> "
}


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    debian_chroot_string='${debian_chroot:+($debian_chroot)}'
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
   if [ $USER == 'root' ];then
      # red
      prompt_user='\[\e[37;41m\]\u\[\e[0m\]'
   elif [ $USER == 'danrabinowitz' ] || [ $USER == 'djr' ]; then
      # no color
      prompt_user='\u'
   else
      # DIFFERENT COLOR
      prompt_user='\[\e[37;41m\]\u\[\e[0m\]'
   fi
   # TODO: DJR: 12/22/10: Consider adding color depending on which host we're on.  Like red for VHGDB.
else
   prompt_user='\u'
fi

prompt_host='\H'
if [ "$color_prompt" = yes ]; then
  if [ `hostname` == 'VHGDB-Testing' ];then
    COLOR="${BLUE}"
    prompt_host=${COLOR}'\H'${PS_CLEAR}
  elif [ `hostname` == 'vhgdb' ]; then
    COLOR="${GREEN_FG_RED_BG}"
    prompt_host=${COLOR}'\H'${PS_CLEAR}
  fi
fi


function set_git_dirty {
    st=$(git status 2>/dev/null | tail -n 1)
    if [[ $st == "" ]]; then
        git_dirty=''
    elif [[ $st == "nothing to commit (working directory clean)" ]]; then
        git_dirty=''
    elif [[ $st == "nothing to commit, working directory clean" ]]; then
        git_dirty=''
    else
        git_dirty='*'
    fi
}


function set_return_value_to_display_in_prompt {
    _ret=$?
    return_value_to_display_in_prompt=''
    if test $_ret -ne 0; then
	return_value_to_display_in_prompt="$_ret:"
	set ?=$_ret
	unset _ret
    fi
}

# NOTE: This is a nice repo. I could probably clean up my .bashrc and structure it into multiple files
#   https://github.com/jimeh/git-aware-prompt


txtylw='\e[0;33m' # Yellow
txtrst='\e[0m'    # Text Reset

prompt_main1=${prompt_user}'@'${prompt_host}':\w$(__git_ps1 " (%s)")'"\[$txtylw\]\$git_dirty\[$txtrst\]"' \$ '
unset prompt_user

PROMPT_COMMAND="set_return_value_to_display_in_prompt; set_git_dirty; history -a; history -n; $PROMPT_COMMAND"
export PS1="\$return_value_to_display_in_prompt"'${debian_chroot_string}'"$prompt_main1"
unset prompt_main1

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot_string}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

unset force_color_prompt debian_chroot_string debian_chroot

# ----------------------------------------------------------------------
# MACOS X / DARWIN SPECIFIC
# ----------------------------------------------------------------------

if [ "$UNAME" = Darwin ]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
fi

# ----------------------------------------------------------------------
# ALIASES / FUNCTIONS
# ----------------------------------------------------------------------

# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'
alias fn='find . -name'
alias hi='history | tail -20'
alias rm="rm -i"



# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi


# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /opt/local/etc/bash_completion \
                 /etc/bash_completion
        do
            test -f $f && {
                . $f
                break
            }
        done
    }
    unset bash bmajor bminor
}

# override and disable tilde expansion
_expand() {
    return 0
}

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

# we always pass these to ls(1)
#LS_COMMON="-hBFG"
LS_COMMON="-hF"

#alias ls="ls -FG"

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
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# setup the main ls alias
alias ls="command ls $LS_COMMON $LS_COLOR"

# these use the ls aliases above
alias ll="ls -l"
alias l.="ls -d .*"

# --------------------------------------------------------------------
# MISC COMMANDS
# --------------------------------------------------------------------

# push SSH public key to another box
push_VHG_ssh_cert() {
    local _host
    key_pub='/Volumes/VHG-Dan/dot/ssh/id_dsa.pub'
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'mkdir -p .ssh;cat >> ~/.ssh/authorized_keys' < $key_pub
    done
}

push_USM_ssh_cert() {
    local _host
    key_pub='/Volumes/USM-Dan/dot/ssh/id_dsa.pub'
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'mkdir -p .ssh;cat >> ~/.ssh/authorized_keys' < $key_pub
    done
}

set_iterm_bgcolor () {
   local R=$1
   local G=$2
   local B=$3
   /usr/bin/osascript <<EOF
tell application "iTerm"
    tell the first terminal
        tell the current session
            set background color to {$(($R*65535/255)), $(($G*65535/255)), $(($B*65535/255))}
        end tell
    end tell
end tell
EOF
}

# --------------------------------------------------------------------
# PATH MANIPULATION FUNCTIONS
# --------------------------------------------------------------------

# Usage: pls [<var>]
# List path entries of PATH or environment variable <var>.
pls () { eval echo \$${1:-PATH} |tr : '\n'; }

# Usage: pshift [-n <num>] [<var>]
# Shift <num> entries off the front of PATH or environment var <var>.
# with the <var> option. Useful: pshift $(pwd)
pshift () {
    local n=1
    [ "$1" = "-n" ] && { n=$(( $2 + 1 )); shift 2; }
    eval "${1:-PATH}='$(pls |tail -n +$n |tr '\n' :)'"
}

# Usage: ppop [-n <num>] [<var>]
# Pop <num> entries off the end of PATH or environment variable <var>.
ppop () {
    local n=1 i=0
    [ "$1" = "-n" ] && { n=$2; shift 2; }
    while [ $i -lt $n ]
    do eval "${1:-PATH}='\${${1:-PATH}%:*}'"
       i=$(( i + 1 ))
    done
}

# Usage: prm <path> [<var>]
# Remove <path> from PATH or environment variable <var>.
prm () { eval "${2:-PATH}='$(pls $2 |grep -v "^$1\$" |tr '\n' :)'"; }

# Usage: punshift <path> [<var>]
# Shift <path> onto the beginning of PATH or environment variable <var>.
punshift () { eval "${2:-PATH}='$1:$(eval echo \$${2:-PATH})'"; }

# Usage: ppush <path> [<var>]
ppush () { eval "${2:-PATH}='$(eval echo \$${2:-PATH})':$1"; }

# Usage: puniq [<path>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () {
    echo "$1" |tr : '\n' |nl |sort -u -k 2,2 |sort -n |
    cut -f 2- |tr '\n' : |sed -e 's/:$//' -e 's/^://'
}

# use gem-man(1) if available:
man () {
    gem man -s "$@" 2>/dev/null ||
    command man "$@"
}

# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

# bring in rbdev functions
#. rbdev 2>/dev/null || true

# source ~/.shenv now if it exists
#test -r ~/.shenv &&
#. ~/.shenv

# condense PATH entries
PATH=$(puniq $PATH)
MANPATH=$(puniq $MANPATH)

# Use the color prompt by default when interactive
#test -n "$PS1" &&
#prompt_color

# -------------------------------------------------------------------
# MOTD / FORTUNE
# -------------------------------------------------------------------

test -n "$INTERACTIVE" -a -n "$LOGIN" && {
    uname -npsr
    uptime
}


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


complete -c -f command sudo

# Begin block: Copied from old ~/.profile file
_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`#cat ~/.ssh/known_hosts | \
                        #cut -f 1 -d ' ' | \
                        #sed -e s/,.*//g | \
                        #grep -v ^# | \
                        #uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

#complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
### End block

# TODO: Consider this idea
# Create a temp file at the start of .bashrc, and delete it at the end.
# Check if it exists on starting .bashrc, and if it does then exit, assuming that there's a problem with .bashrc


# -------------------------------------------------------------------
# Dan's Custom stuff: VHG
# -------------------------------------------------------------------
#RAILS_ENV=

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

real_rails=`which rails`
rails() {
    args="$@"
#    echo $1
    if [ "$1" == "db" ]; then
        args="$args --include-password"
        echo "Running rails db with --include-password appended"
    fi
#    echo "$args"
    "$real_rails" $args
}

alias r=rails

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

alias man='man -P less'

export GIT_AUTHOR_NAME="Dan Rabinowitz"

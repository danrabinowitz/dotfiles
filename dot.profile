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

# -------------------------------------------------------------------
# Dan's Custom stuff: VHG
# -------------------------------------------------------------------
#RAILS_ENV=

if [ -f ~/.profile_local ]; then
    . ~/.profile_local
fi
=======

# ~/.bash_profile
# This file is designed to work on OS X and Debian

###############################################################################
echo "Start of .bash_profile"

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

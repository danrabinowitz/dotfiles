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

PATH=/usr/local/bin:/usr/local/sbin:$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

if [ -f "$HOME/.dotfiles.git/dot.bash_profile_livingsocial_dev" ]; then
    . "$HOME/.dotfiles.git/dot.bash_profile_livingsocial_dev"
fi

# The following 3 lines, which must be near the END of the file, tell Emacs to use sh mode for this file
# Local Variables:
# mode: sh
# End:

# ~/.profile
# For notes about this file, and what goes in ~/.bash_profile versus ~/.profile versus ~/.bashrc see Bash_Dotfiles.txt

#############################################################################
# This file is designed to work on OS X and Debian

# TODO:

echo "Start of ~/.profile"

################################################################################
# Below here is for stuff which is "run time modifying" stuff

# The default umask is set in /etc/profile
# On debian, for setting the umask for ssh logins, install and configure the libpam-umask package.
# TODO: Can we check if debian and if libpam-umask is installed and warn if not?
# default umask
umask 0022

# disable core dumps
ulimit -S -c 0

# PATH STUFF
. ~/Config/bash/path




################################################################################
# Stuff that is not bash-specific and not specific to interactive use, but which is NOT "run time modifying" stuf
# This environment variable is NOT bash-specific and not specific to interactive use. So I am trying to put it in .profile
export GIT_AUTHOR_NAME="Dan Rabinowitz"

# Shell options which could be useful in a non-interactive session
shopt -s extglob >/dev/null 2>&1





if [ -f ~/.profile_local ]; then
    . ~/.profile_local
fi

export CLICOLOR=1

# TODO: Output to a log that .profile was run. Include the date, the PID, the PPID, etc.


# The following 3 lines, which must be near the END of the file, tell Emacs to use sh mode for this file
# Local Variables:
# mode: sh
# End:

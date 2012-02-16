# ~/.profile
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
# End of discussion
###############################################################################
# Tests
echo "start of .profile"

if [ -f ~/.profile_local ]; then
    . ~/.profile_local
fi

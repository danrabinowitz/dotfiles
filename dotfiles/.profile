# ~/.profile
# For notes about this file, and what goes in ~/.bash_profile versus ~/.profile versus ~/.bashrc see Bash_Dotfiles.txt

#############################################################################
# This file should work on OS X and Linux (Debian, Ubuntu)
# This file should work with bash as well as from zsh via `emulate sh -c 'source ~/.profile'`

################################################################################
# FUNCTION_DEFINITIONS: Utility
################################################################################
function set_is_macos {
  if [ "$(uname -s)" = "Darwin" ]; then
    IS_MACOS=1
  fi
}
set_is_macos

default_log_filename="${HOME}/.profile.log"
LOG_FILENAME=${LOG_FILENAME:-$default_log_filename}
LOG_TO_STDOUT=true
function log {
  if [ -n "$IS_MACOS" ]; then
    echo "TODO: Make sure gdate exists"
    local msg="[$(gdate +%s.%N)]: $*"
  else
    local msg="[$(date --rfc-3339=seconds)]: $*"
  fi
  echo "${msg}" >> "${LOG_FILENAME}"
  if [ "${LOG_TO_STDOUT}" = "true" ]; then
    echo "${msg}"
  fi
}

if [ -n "$LOG_DOTFILE_TIMES" ]; then
  log "-----: Start of ~/.profile"
fi

[ -r ~/.profile_local ] && source ~/.profile_local

default_dotfiles_dir="${HOME}/.dotfiles"
DJR_DOTFILES_DIR=${DJR_DOTFILES_DIR:-$default_dotfiles_dir}
#echo "DJR_DOTFILES_DIR=$DJR_DOTFILES_DIR"

################################################################################
# Config check
################################################################################
function check_config {
  check_config_called=1
  local cache_dir="${HOME}/tmp/cache"
  # 1) Abort if we checked recently
  echo "TODO: check_config"

  # 2) Check the config
  if [ ! -r ~/.gitignore_global ]; then
    echo "WARNING: ~/.gitignore_global is not present"
  fi
  # 3) Track that we just checked
  
}
#check_config

################################################################################
# DigitalOcean
GOPRIVATE="*.internal.digitalocean.com,github.com/digitalocean"
echo "TODO: Add logic to GOPRIVATE or move it to _local"
################################################################################

################################################################################
# Below here is for stuff which is "run time modifying" stuff

# The default umask is set in /etc/profile
# On debian, for setting the umask for ssh logins, install and configure the libpam-umask package.
# TODO: Can we check if debian and if libpam-umask is installed and warn if not?
# default umask
# Let's default to "0077" and then we can override that in .profile_local as needed.
umask 0077

# disable core dumps
ulimit -S -c 0

# Set PATH
[ -r "${DJR_DOTFILES_DIR}/lib/bash/path" ] && emulate sh -c "source ${DJR_DOTFILES_DIR}/lib/bash/path"

################################################################################
# Stuff that is not bash-specific and not specific to interactive use, but which is NOT "run time modifying" stuff
# Shell options which could be useful in a non-interactive session
if [ -e /Users/djr/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/djr/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# This next line seems to work on bash, but not zsh
# TODO: Switch based on zsh version
# shopt -s extglob >/dev/null 2>&1

# TODO: Output to a log that .profile was run. Include the date, the PID, the PPID, etc.
if [ -n "$LOG_DOTFILE_TIMES" ]; then
  log "End of ~/.profile"
fi

# The following 3 lines, which must be near the END of the file, tell Emacs to use sh mode for this file
# Local Variables:
# mode: sh
# End:

# Shared environment for Bash and Zsh, including noninteractive Bash.

# Portable timestamps are only generated when logging is explicitly enabled.
LOG_FILENAME=${LOG_FILENAME:-$HOME/.profile.log}
LOG_TO_STDOUT=true
function log {
  local msg="[$(date -u +'%Y-%m-%dT%H:%M:%SZ')]: $*"
  printf '%s\n' "$msg" >> "$LOG_FILENAME"
  if [ "$LOG_TO_STDOUT" = "true" ]; then
    printf '%s\n' "$msg"
  fi
}

if [ -n "$LOG_DOTFILE_TIMES" ]; then
  log "Start of ~/.profile"
fi

[ -r ~/.profile_local ] && source ~/.profile_local

DJR_DOTFILES_DIR=${DJR_DOTFILES_DIR:-$HOME/.dotfiles.git}
umask 0077
ulimit -S -c 0

[ -r "$DJR_DOTFILES_DIR/lib/bash/path" ] && source "$DJR_DOTFILES_DIR/lib/bash/path"

[ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

if [ -n "$LOG_DOTFILE_TIMES" ]; then
  log "End of ~/.profile"
fi

# Same-shell guards in Bash and Zsh avoid duplicate startup work. This is not
# exported, so new shells still load the environment and machine-local overrides.
PROFILE_SOURCED=1

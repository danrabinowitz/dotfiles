# # When the next line is enabled and zprof is on the last line of .zshrc, provides profile information.
# zmodload zsh/zprof

# Nice post on zsh optimization
# https://htr3n.github.io/2018/07/faster-zsh/
# and another: https://joshghent.com/zsh-speed/

#LOG_DOTFILE_TIMES=1
# Initially copied from @fatih
# =============
#    NON-INTERACTIVE
# =============
# Login shells already sourced ~/.profile from ~/.zprofile. Non-login
# interactive shells still need it. PROFILE_SOURCED is not exported, so a
# nested zsh sources ~/.profile itself.
if [ -z "$PROFILE_SOURCED" ]; then
  [ -r ~/.profile ] && emulate sh -c 'source ~/.profile'
fi

# =============
#    INTERACTIVE
# =============
# TODO: Move this out of the $HOME dir
[ -r ~/.profile_interactive ] && source ~/.profile_interactive

# =============
#    HISTORY
# =============

## Command history configuration
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=1000000
SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
# ignore duplication command history list
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
# share command history data
setopt share_history

# Orca scopes history to each worktree by default. Keep the normal global
# history so Orca shares it with Ghostty, and override Orca's saved path so its
# deferred startup does not switch HISTFILE back to the worktree file.
if [[ -n "${_orca_histfile:-}" ]]; then
  HISTFILE="$HOME/.zsh_history"
  _orca_histfile="$HISTFILE"
fi

# ===================
#    AUTOCOMPLETION
# ===================
# enable completion
autoload -Uz compinit && compinit -u

zmodload -i zsh/complist

WORDCHARS=''

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# autocompletion with an arrow-key driven interface
zstyle ':completion:*:*:*:*:*' menu select

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

zstyle '*' single-ignored show

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true

# ===================
#    KEY BINDINGS
# ===================
# Use emacs-like key bindings by default:
bindkey -e

# [Ctrl-r] - Search backward incrementally for a specified string. The string
# may begin with ^ to anchor the search to the beginning of the line.
if [ -n "$HISTDB_FILE" ]; then
  bindkey '^r' _histdb-isearch
else
  bindkey '^r' history-incremental-search-backward
fi

if [[ "${terminfo[kpp]}" != "" ]]; then
  bindkey "${terminfo[kpp]}" up-line-or-history       # [PageUp] - Up a line of history
fi

if [[ "${terminfo[knp]}" != "" ]]; then
  bindkey "${terminfo[knp]}" down-line-or-history     # [PageDown] - Down a line of history
fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi

if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi
if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char            # [Delete] - delete forward
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search



# ===================
#    MISC SETTINGS
# ===================

# automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

# ===================
#    PLUGINS
# ===================

# Return the first readable file in REPLY. Source it at the top level:
# sourcing plugins inside this helper could change their variable scope.
function _zsh_first_file {
  local candidate
  for candidate in "$@"; do
    if [ -f "$candidate" ]; then
      REPLY="$candidate"
      return 0
    fi
  done
  return 1
}

function _zsh_warn_missing {
  printf '%s\n' "$1"
  printf '  Install: %s\n' "$3"
  printf '  Source: %s\n' "$2"
}

# Keep successful tool checks quiet; offer installation help on failure.
function _zsh_require_tool {
  local command="$1"
  shift
  if type "$command" >/dev/null 2>&1; then
    return 0
  fi
  _zsh_warn_missing "$@"
  return 1
}

if _zsh_first_file \
  "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "$HOME/.nix-flake/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
then
  source "$REPLY"
else
  _zsh_warn_missing \
    'WARNING: zsh-syntax-highlighting is not installed' \
    'https://github.com/zsh-users/zsh-syntax-highlighting' \
    'brew install zsh-syntax-highlighting'
fi

if _zsh_first_file \
  "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "$HOME/.nix-flake/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
then
  source "$REPLY"
else
  _zsh_warn_missing \
    'WARNING: zsh-autosuggestions is not installed' \
    'https://github.com/zsh-users/zsh-autosuggestions' \
    'brew install zsh-autosuggestions'
fi

#bindkey '^[c' autosuggest-clear
#bindkey '^ ' autosuggest-accept

# ===================
#    THIRD PARTY
# ===================
# jump
if _zsh_require_tool jump \
  'WARNING: jump is not installed' \
  'https://github.com/gsamokovarov/jump' \
  'brew install jump'
then
  eval "$(jump shell zsh)"
fi

# tab completion for sshrc
# compdef sshrc=ssh

# direnv
if _zsh_require_tool direnv \
  'WARNING: direnv is not installed' \
  'https://github.com/direnv/direnv' \
  'brew install direnv'
then
  # `direnv hook` and `direnv export` each start a process. Remember the
  # binary path once, and run export only when this tree has an .envrc or
  # direnv has already loaded one (so leaving that directory still unloads).
  typeset -g _DIRENV_BIN=${commands[direnv]}
  _direnv_hook() {
    setopt localoptions localtraps
    if [[ ! -o interactive || $ZSH_SUBSHELL -ne 0 ]]; then
      return
    fi
    if [[ -z ${DIRENV_DIR:-} ]]; then
      local dir=$PWD found=
      while true; do
        if [[ -f "$dir/.envrc" ]]; then
          found=1
          break
        fi
        [[ $dir == / ]] && break
        dir=${dir:h}
      done
      [[ -n $found ]] || return
    fi
    local vars
    vars="$("$_DIRENV_BIN" export zsh)"
    trap -- '' SIGINT
    eval "$vars"
    trap - SIGINT
  }
  typeset -ag precmd_functions
  if (( ! ${precmd_functions[(I)_direnv_hook]} )); then
    precmd_functions=(_direnv_hook $precmd_functions)
  fi
  typeset -ag chpwd_functions
  if (( ! ${chpwd_functions[(I)_direnv_hook]} )); then
    chpwd_functions=(_direnv_hook $chpwd_functions)
  fi
fi

# NOTE: Set this in interactive shells only
HOMEBREW_BUNDLE_FILE="~/.Brewfile"

if [ -n "$LOG_DOTFILE_TIMES" ]; then
  log "end of .zshrc"
fi

[ -f "/Users/djr/.ghcup/env" ] && source "/Users/djr/.ghcup/env" # ghcup-env

# PURE!

_zsh_require_tool delta \
  'WARNING: git-delta is not installed' \
  'https://dandavison.github.io/delta/installation.html or https://github.com/dandavison/delta' \
  'brew install git-delta'

if [ -r "$HOME/.nix-profile/share/zsh/site-functions/prompt_pure_setup" ] || [ -r "$HOME/.nix-flake/share/zsh/site-functions/prompt_pure_setup" ] || [ -r "/usr/local/lib/node_modules/pure-prompt" ] || [ -r "$HOME/.zsh/pure" ]; then
  if [ -r "$HOME/.nix-profile/share/zsh/site-functions/prompt_pure_setup" ]; then
    fpath+="$HOME/.nix-profile/share/zsh/site-functions"
  elif [ -r "$HOME/.zsh/pure" ]; then
    fpath+=$HOME/.zsh/pure
  fi

  # Substring check. `echo | grep` forked on every interactive start.
  if [[ $PATH == */nix/store* ]]; then
    export IN_NIX_SHELL="yes"
  else
    unset IN_NIX_SHELL
  fi

  # Pure adds only a few ms
  # https://github.com/sindresorhus/pure
  autoload -U promptinit; promptinit
  zstyle :prompt:pure:git:stash show yes
  zstyle :prompt:pure:path color cyan
  zstyle :prompt:pure:prompt:success color green
  zstyle :prompt:pure:host color red
  zstyle :prompt:pure:user color magenta
  # zstyle :prompt:pure:environment:nix-shell show no

  prompt pure

else


  echo "WARNING: pure is not installed"
  echo "  source: https://github.com/sindresorhus/pure"
  echo '  Run `npm install --global pure-prompt` to install'

  # starship adds 60 ms in a ruby directory, and 10 or 20 ms in other directories
  # https://starship.rs/
  if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
  else
    echo "WARNING: neither pure nor starship is installed"
  fi
fi

if _zsh_require_tool fzf \
  'WARNING: fzf is not installed' \
  'https://github.com/junegunn/fzf' \
  'git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install'
then
  if [ -r ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
  else
    _zsh_warn_missing \
      'WARNING: ~/.fzf.zsh is not readable' \
      'https://github.com/junegunn/fzf' \
      'git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install'
  fi
fi

if ! type "nix-env" > /dev/null; then
  echo "WARNING: nix is not installed"
  echo "  source: https://zero-to-nix.com/start/install"
fi

# Keep helper functions out of the interactive shell.
unfunction _zsh_first_file _zsh_warn_missing _zsh_require_tool
unset REPLY

if [ -f "$HOME/.zshrc_local" ]; then
    . "$HOME/.zshrc_local"
fi

###
# docc completion seems to require vpn and hangs with no vpn. Test this.
#if command -v docc &> /dev/null; then
#  source <(SYSLOG_OFF=true docc completion zsh)
#fi

# NOTE: Using https://github.com/romkatv/zsh-prompt-benchmark I have the prompt benchmarked to 30ms.

# # When the next line is enabled and zmodload zsh/zprof is on the first line of .zshrc, provides profile information.
# zprof

# # Enabling the next line allows us to run zsh-prompt-benchmark
# source ~/code/src/github.com/romkatv/zsh-prompt-benchmark/zsh-prompt-benchmark.plugin.zsh
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/Users/djr/.opencode/bin:$PATH

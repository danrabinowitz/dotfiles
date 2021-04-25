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
[ -r ~/.profile ] && emulate sh -c 'source ~/.profile'

# =============
#    INTERACTIVE
# =============
# TODO: Move this out of the $HOME dir
[ -r ~/.profile_interactive ] && source ~/.profile_interactive

# =============
#    CONFIG CHECK
# =============
#if [ -z "$check_config_called" ]; then
#  echo "WARNING: Config check not detected"
#fi

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

# ===================
#    AUTOCOMPLETION
# ===================
# enable completion
autoload -Uz compinit && compinit

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
bindkey '^r' history-incremental-search-backward      

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

# brew install zsh-syntax-highlighting
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# brew install zsh-autosuggestions
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

#bindkey '^[c' autosuggest-clear
#bindkey '^ ' autosuggest-accept

# ===================
#    THIRD PARTY
# ===================
# jump
if ! type "jump" > /dev/null; then
  echo "WARNING: jump is not installed"
  echo "  source: https://github.com/gsamokovarov/jump"
  case "$OSTYPE" in
    darwin*)
      echo '  Run `brew install jump` to install'
    ;;
    linux*)
      echo "  Run... TODO"
    ;;
    *)
      echo "  WARNING: Unknown OSTYPE=${OSTYPE}"
    ;;
  esac
else
  eval "$(jump shell)"
fi

# tab completion for sshrc
# compdef sshrc=ssh

# direnv
if ! type "direnv" > /dev/null; then
  echo "WARNING: direnv is not installed"
  echo "  source: https://github.com/direnv/direnv"
  case "$OSTYPE" in
    darwin*)
      echo '  Run `brew install direnv` to install'
    ;;
    linux*)
      echo "  Run... TODO"
    ;;
    *)
      echo "  WARNING: Unknown OSTYPE=${OSTYPE}"
    ;;
  esac
else
  eval "$(direnv hook zsh)"
fi

# NOTE: Set this in interactive shells only
HOMEBREW_BUNDLE_FILE="~/.Brewfile"

if [ -n "$LOG_DOTFILE_TIMES" ]; then
  log "end of .zshrc"
fi

[ -f "/Users/djr/.ghcup/env" ] && source "/Users/djr/.ghcup/env" # ghcup-env

# PURE!


if ! type "jump" > /dev/null; then
  echo "WARNING: jump is not installed"
  echo "  source: https://github.com/gsamokovarov/jump"
  case "$OSTYPE" in
    darwin*)
      echo '  Run `brew install jump` to install'
    ;;
    linux*)
      echo "  Run... TODO"
    ;;
    *)
      echo "  WARNING: Unknown OSTYPE=${OSTYPE}"
    ;;
  esac
else
  eval "$(jump shell)"
fi

if ! type "diff-so-fancy" > /dev/null; then
  echo "WARNING: diff-so-fancy is not installed"
  echo "  source: https://github.com/so-fancy/diff-so-fancy"
  case "$OSTYPE" in
    darwin*)
      echo '  Run `brew install diff-so-fancy` to install'
    ;;
    linux*)
      echo "  Run... TODO"
    ;;
    *)
      echo "  WARNING: Unknown OSTYPE=${OSTYPE}"
    ;;
  esac
fi



if [ -r /usr/local/lib/node_modules/pure-prompt ] || [ -r "$HOME/.zsh/pure" ] ; then
  if [ ! -r /usr/local/lib/node_modules/pure-prompt ]; then
    fpath+=$HOME/.zsh/pure
  fi
  # Pure adds only a few ms
  # https://github.com/sindresorhus/pure
  autoload -U promptinit; promptinit
  zstyle :prompt:pure:git:stash show yes
  zstyle :prompt:pure:path color cyan
  zstyle :prompt:pure:prompt:success color green
  zstyle :prompt:pure:host color red
  zstyle :prompt:pure:user color magenta

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

# Enabling this adds 10 ms to prompt times per zsh-prompt-benchmark
# if [[ -r "/usr/local/opt/mcfly/mcfly.zsh" ]]; then
#   export MCFLY_FUZZY=true
#   source "/usr/local/opt/mcfly/mcfly.zsh"
# else

if ! type "fzf" > /dev/null; then
  echo "WARNING: fzf is not installed"
  echo "  source: https://github.com/junegunn/fzf"
  case "$OSTYPE" in
    darwin*)
      echo '  Run `brew install fzf && $(brew --prefix)/opt/fzf/install` to install'
    ;;
    linux*)
      echo "  Run... TODO"
    ;;
    *)
      echo "  WARNING: Unknown OSTYPE=${OSTYPE}"
    ;;
  esac
else
  if [ ! -r ~/.fzf.zsh ]; then
    echo "WARNING: ~/.fzf.zsh is not readable"
    case "$OSTYPE" in
      darwin*)
        echo '  Run `$(brew --prefix)/opt/fzf/install` to install'
      ;;
      linux*)
        echo "  Run... TODO"
      ;;
      *)
        echo "  WARNING: Unknown OSTYPE=${OSTYPE}"
      ;;
    esac
  else
    source ~/.fzf.zsh
  fi
fi

# fi

###
# docc completion seems to require vpn and hangs with no vpn. Test this.
#if command -v docc &> /dev/null; then
#  source <(SYSLOG_OFF=true docc completion zsh)
#fi

# # Enabling this changes the results of zsh-prompt-benchmark from 40ms to 170ms
# if command -v change-tab-color-pwd &> /dev/null; then
#   function tab_color_precmd {
#     change-tab-color-pwd 0.5 0.5
#   }
#   autoload -U add-zsh-hook
#   add-zsh-hook precmd tab_color_precmd
# fi

# NOTE: Using https://github.com/romkatv/zsh-prompt-benchmark I have the prompt benchmarked to 30ms.

# # When the next line is enabled and zmodload zsh/zprof is on the first line of .zshrc, provides profile information.
# zprof

# # Enabling the next line allows us to run zsh-prompt-benchmark
# source ~/zsh-prompt-benchmark/zsh-prompt-benchmark.plugin.zsh

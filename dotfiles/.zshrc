# Initially copied from @fatih
# =============
#    NON-INTERACTIVE
# =============
[ -r ~/.profile ] && emulate sh -c 'source ~/.profile'

# =============
#    INTERACTIVE
# =============
source ~/.profile_interactive

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

# =============
#    PROMPT
# =============
autoload -U colors && colors
setopt promptsubst


# START OF prompt_user_host CODE
function get_prompt_user_host() {
  local h99=`hostname`
  local prompt_host='%m'
  if [ "$h99" = 'Dans-MBP.local' ]; then
    prompt_host='%m'
  elif [ "$h99" = 'devenv-blue' ]; then
    local COLOR="%{$fg_bold[blue]%}"
    prompt_host=${COLOR}'%m'%{$reset_color%}
  # elif [ "$h99" = 'x' ]; then
  #   local COLOR="%{$fg_bold[green]$bg_bold[red]%}"
  #   prompt_host=${COLOR}'%m'%{$reset_color%}
  else
    local COLOR="%{$fg_bold[green]$bg_bold[red]%}"
    prompt_host=${COLOR}'%m'%{$reset_color%}
  fi

  local prompt_user=""
  if [ "$USER" = 'root' ];then
    # red
    prompt_user='%{$fg_bold[red]%}%n%{$reset_color%}'
  elif [ "$USER" = 'djradmin' ]; then
    prompt_user='%{$fg_bold[magenta]%}%n%{$reset_color%}'
  elif [ "$USER" = 'danrabinowitz' ] || [ "$USER" = 'djr' ]; then
    # no color
    prompt_user=''
  else
    # DIFFERENT COLOR
    prompt_user='%{$fg_bold[yellow]%}%n%{$reset_color%}'
  fi

  local prompt_user_host=""
  if [ -n "$prompt_user" ] && [ -n "$prompt_host" ]; then
    prompt_user_host=${prompt_user}'@'${prompt_host}
  else
    prompt_user_host=${prompt_user}${prompt_host}
  fi
  if [ -n "$prompt_user_host" ] ; then
    prompt_user_host=${prompt_user_host}':'
  fi
  echo "$prompt_user_host"
}
prompt_user_host=$(get_prompt_user_host)
# END OF prompt_user_host CODE

local ret_status="%(?:%{$fg_bold[green]%}$:%{$fg_bold[green]%}$)"
# PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
PROMPT='${prompt_user_host}${ret_status} %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

function git_stash_size() {
 lines=$(git stash list -n 100 2> /dev/null) || return
 if [ "${#lines}" -gt 0 ]
 then
   count=$(echo "$lines" | wc -l | sed 's/^[ \t]*//') # strip tabs
   echo " ["${count#} "stash] "
 fi
}

# Outputs current branch info in prompt format
function git_prompt_info() {
  local ref
  if [[ "$(command git config --get customzsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$(git_stash_size)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS=''
  local FLAGS
  FLAGS=('--porcelain')

  if [[ "$(command git config --get customzsh.hide-dirty)" != "1" ]]; then
    FLAGS+='--ignore-submodules=dirty'
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi

  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# ===================
#    AUTOCOMPLETION
# ===================
# enable completion
autoload -Uz compinit
compinit

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

autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
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
# brew install jump
# https://github.com/gsamokovarov/jump
eval "$(jump shell)"

# tab completion for sshrc
compdef sshrc=ssh

# brew install direnv
# https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

if [ -n "$LOG_DOTFILE_TIMES" ]; then
  log "end of .zshrc"
fi

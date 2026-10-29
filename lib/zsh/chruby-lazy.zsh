# chruby.sh runs `ls` on ruby directories when it is sourced. Defer that
# until `chruby` is called or a command runs in a tree with .ruby-version.
# auto.sh then installs chruby_auto, same as sourcing both files up front.
#
# This file may be sourced under `emulate sh`. Functions switch back to zsh.

if [ -n "${_CHRUBY_LAZY:-}" ]; then
  return
fi
_CHRUBY_LAZY=1

_chruby_load() {
  emulate -L zsh
  [[ -n ${_CHRUBY_LOADED:-} ]] && return 0
  local root=/opt/homebrew/opt/chruby/share/chruby
  [[ -r "$root/chruby.sh" && -r "$root/auto.sh" ]] || return 1
  _CHRUBY_LOADED=1
  source "$root/chruby.sh"
  source "$root/auto.sh"
  # Name must not contain the substring chruby_auto. auto.sh uses that
  # match to decide whether its hook is already installed.
  preexec_functions=("${(@)preexec_functions:#_chruby_lazy_preexec}")
}

chruby() {
  emulate -L zsh
  _chruby_load || return 1
  chruby "$@"
}

_chruby_lazy_preexec() {
  emulate -L zsh
  local dir="$PWD/"
  until [[ -z "$dir" ]]; do
    dir="${dir%/*}"
    if [[ -r "$dir/.ruby-version" ]]; then
      _chruby_load || return
      chruby_auto
      return
    fi
  done
}

_chruby_lazy_setup() {
  emulate -L zsh
  local root=/opt/homebrew/opt/chruby/share/chruby
  [[ -r "$root/chruby.sh" && -r "$root/auto.sh" ]] || return 0
  preexec_functions+=(_chruby_lazy_preexec)
}
_chruby_lazy_setup
unset -f _chruby_lazy_setup

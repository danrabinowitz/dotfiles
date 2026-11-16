# This is the personal "dotfiles" repo of Dan Rabinowitz. YMMV.




To install these dotfiles on a new machine:
ssh -A user@host
# git clone git@github.com:danrabinowitz/dotfiles.git
# mv dotfiles .dotfiles.git
# cd .dotfiles.git
# git status
# ./bin/install
# exit

ssh user@host
> Check that things look good

## Shell startup

- `~/.profile` holds shared environment setup and loads `lib/bash/path` for PATH.
- Bash login shells load `.profile`, then `.bashrc`; `.bashrc` uses
  `PROFILE_SOURCED` to avoid importing the shared environment twice.
  Non-login and noninteractive Bash shells still load it directly before
  `.bashrc` returns to interactive-only setup.
- A machine-local `.zprofile` loads `.profile` for login Zsh. `.zshrc` loads it
  when needed for other interactive shells, then handles Zsh-specific setup.
- `.profile_interactive` holds shared Bash/Zsh aliases, editor settings, and
  terminal colors. The shared `lib/bash/` files work in both shells.

Machine-local overrides are loaded at the corresponding stage:
`.profile_local`, `.profile_interactive_local`, `.bash_profile_local`,
`.bashrc_local`, and `.zshrc_local`. `PROFILE_SOURCED` is deliberately not
exported, so new shells still load local overrides.

## Nested dotfiles

`bin/install` only symlinks the flat files in `dotfiles/` to `$HOME/<name>`;
it ignores anything nested. Directories of dotfiles live at the repo root and
are handled separately:

| Path | How it reaches `$HOME` |
| --- | --- |
| `dot.orca/` | **Copied**, not linked — see below |

### Orca keybindings (`dot.orca/keybindings.json`)

Tracked copy of `~/.orca/keybindings.json`.

**Do not symlink this file.** Orca saves it atomically: it writes
`keybindings.json.tmp`, then `rename(2)`s that over the target. A rename
replaces the directory entry, so a symlink into this repo becomes a regular
file on the first save — and the tracked copy silently goes stale from then
on. A whole-directory symlink would survive, but `~/.orca/` also holds
`jira-tokens/` and other machine-local state, so that is not an option.

Sync explicitly with `bin/orca-keybindings`:

```sh
# Machine where the shortcut was changed (Orca can stay running):
~/.dotfiles.git/bin/orca-keybindings save
git -C ~/.dotfiles.git add dot.orca/keybindings.json
git -C ~/.dotfiles.git commit -m "Orca keybindings"
git -C ~/.dotfiles.git push

# Other machine: pull, then quit Orca before loading.
git -C ~/.dotfiles.git pull
~/.dotfiles.git/bin/orca-keybindings load
```

`~/.dotfiles.git/bin` is not on `PATH` here, so use the full path (or add it to
`path` in `.zshrc`). Verify with `~/.dotfiles.git/bin/orca-keybindings diff`.

Why quit first: Orca does not watch the file, and it writes its in-memory
shortcut state back on the next save, which would clobber a load made while it
was running.


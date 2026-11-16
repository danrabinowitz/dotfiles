# Personal dotfiles

YMMV.

## Install

The canonical checkout is `$HOME/.dotfiles.git`. The installer links each flat
file in `dotfiles/` directly into `$HOME`; it does not create a `~/.dotfiles`
alias or depend on the directory from which it is invoked.

For a new machine:

```sh
# Skip this command when already working on the target machine.
ssh -A user@host
git clone git@github.com:danrabinowitz/dotfiles.git "$HOME/.dotfiles.git"
cd "$HOME/.dotfiles.git"
git status
./bin/install --dry-run
./bin/install
```

Installer behavior:

- **Normal files:** preserved as `<name>_orig`, or `<name>_orig.N` if the first
  backup already exists. Existing backups are never overwritten.
- **Equivalent legacy links:** replaced with direct links to this checkout.
- **Unrelated or dangling symlinks, and existing directories:** stop the entire
  installation before anything is changed. Inspect and move these manually,
  then rerun the installer.
- **Up-to-date links:** left alone; rerunning installation is idempotent.

`./bin/install check` and `./bin/install --dry-run` make no changes and print
what installation would do. They return nonzero for conflicts, not merely for
missing or uninstalled links.

On an existing machine, review repository changes and then migrate the links:

```sh
cd "$HOME/.dotfiles.git"
git pull --ff-only
./bin/install --dry-run
./bin/install
./bin/install check
```

The old `~/.dotfiles` alias is not removed, so machine-local references to it
keep working. The installer no longer creates new references through it. Files
that are not in the `dotfiles/` manifest are not touched, including removed
Emacs and tmux configs.

For a checkout outside `$HOME/.dotfiles.git`, the installer uses absolute link
targets. Set `DJR_DOTFILES_DIR` to that checkout in `~/.profile_local` so the
shell finds its shared libraries too; otherwise it defaults to
`$HOME/.dotfiles.git`.

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


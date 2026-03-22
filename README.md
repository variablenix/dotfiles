# dotfiles

Personal shell configuration files for Debian/Ubuntu servers and macOS.
Covers aliases, Vim, and tmux — kept minimal, well-commented, and safe to deploy on any machine.

## Files

| File | Purpose |
|------|---------|
| [.aliases](.aliases) | Shell aliases — navigation, git, docker, systemd, WireGuard, and more |
| [.vimrc](.vimrc) | Vim config — vim-plug, fzf, NERDTree, goyo, fugitive |
| [.tmux.conf](.tmux.conf) | tmux config — Ctrl-a prefix, vim pane nav, status bar |

## Install

Clone and symlink to your home directory:

```bash
git clone https://github.com/KDN-Cloud/dotfiles.git ~/dotfiles

ln -sf ~/dotfiles/.aliases ~/.aliases
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
```

Then source aliases in your shell config if not already set up:

```bash
# add to ~/.bashrc or ~/.zshrc
[ -f ~/.aliases ] && source ~/.aliases
```

## Dependencies

### .aliases

```bash
sudo apt install colordiff grc hub
```

- `colordiff` — colored diff output
- `grc` — generic colorizer for ping, netstat, etc.
- `hub` — GitHub CLI wrapper for git (or replace `alias git='hub'` with plain `git`)

### .vimrc

Plugins are managed by [vim-plug](https://github.com/junegunn/vim-plug) and auto-install on first launch. Some plugins require:

```bash
sudo apt install fzf ripgrep curl
```

### .tmux.conf

Requires tmux 3.0+:

```bash
sudo apt install tmux
```

Optional — [tmux plugin manager](https://github.com/tmux-plugins/tpm):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Notes

- `.aliases` uses `alias git='hub'` — remove or change to plain `git` if `hub` is not installed
- `.vimrc` defaults to the `desert` colorscheme (built-in safe fallback) — swap for your preferred scheme
- WireGuard aliases in `.aliases` assume interface `wg0` and subnet `10.69.0.0/24` — adjust to match your setup
- Weather aliases point to Las Vegas — change `wttr.in/Las+Vegas` to your city

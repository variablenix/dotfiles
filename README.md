# dotfiles

![prompt](assets/prompt.png)

Personal shell configuration files for Debian/Ubuntu Linux and macOS.
Organized by platform — `common` files are identical across machines, platform
folders contain OS-specific versions.

## Structure

```
dotfiles/
├── common/                  # identical across all platforms
│   ├── .gitconfig           # git identity, aliases, behavior (fill in name/email)
│   ├── .gitignore_global    # global git ignore — OS files, editor artifacts, secrets
│   ├── .dir_colors          # ls color scheme (Linux: dircolors, macOS: gdircolors)
│   ├── .vimrc               # vim config — vim-plug, fzf, NERDTree, goyo, fugitive
│   └── .tmux.conf           # tmux — Ctrl-a prefix, vim pane nav, vi copy, status bar
├── linux/                   # Debian, Ubuntu, Raspberry Pi OS
│   ├── .bashrc              # bash config — prompt, completions, tool integrations
│   └── .aliases             # aliases — apt, systemd, WireGuard, docker, git
└── macos/                   # macOS (Apple Silicon + Intel)
    ├── .bashrc              # bash config — homebrew, prompt, tool integrations
    └── .aliases             # aliases — brew, open, pbcopy, Finder, docker, git
```

## Prompt

Both Linux and macOS use a two-line prompt:

```
user @ hostname  ~/projects/myrepo  (main)
»
```

- Line 1 — username (green), `@`, hostname (cyan), path (blue), git branch (yellow), venv (white)
- Line 2 — `»` cursor in cyan
- Root sessions show username in red (Linux only)
- Git branch and venv only appear when inside a repo or active virtualenv

## Install

### Linux

```bash
git clone https://github.com/KDN-Cloud/dotfiles.git ~/dotfiles

# common
ln -sf ~/dotfiles/common/.gitconfig        ~/.gitconfig
ln -sf ~/dotfiles/common/.gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/common/.dir_colors       ~/.dir_colors
ln -sf ~/dotfiles/common/.vimrc            ~/.vimrc
ln -sf ~/dotfiles/common/.tmux.conf        ~/.tmux.conf

# linux-specific
ln -sf ~/dotfiles/linux/.bashrc   ~/.bashrc
ln -sf ~/dotfiles/linux/.aliases  ~/.aliases

source ~/.bashrc
```

### macOS

```bash
git clone https://github.com/KDN-Cloud/dotfiles.git ~/dotfiles

# common
ln -sf ~/dotfiles/common/.gitconfig        ~/.gitconfig
ln -sf ~/dotfiles/common/.gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/common/.dir_colors       ~/.dir_colors
ln -sf ~/dotfiles/common/.vimrc            ~/.vimrc
ln -sf ~/dotfiles/common/.tmux.conf        ~/.tmux.conf

# macos-specific
ln -sf ~/dotfiles/macos/.bashrc   ~/.bashrc
ln -sf ~/dotfiles/macos/.aliases  ~/.aliases

source ~/.bashrc
```

Register the global gitignore (if not already in `.gitconfig`):

```bash
git config --global core.excludesfile ~/.gitignore_global
```

## Machine-specific overrides

Create `~/.bashrc.local` for per-machine settings that should never be committed — it is sourced automatically at the end of `.bashrc`:

```bash
# ~/.bashrc.local — machine-specific, not in git
export GIT_AUTHOR_EMAIL="work@company.com"
export SOME_LOCAL_API_KEY="..."
alias gowork='cd ~/work/client-project'
```

Same pattern for git — use `~/.gitconfig-local` via `[includeIf]` (see comments in `common/.gitconfig`).

## Dependencies

### Linux

```bash
sudo apt install colordiff grc hub curl vim tmux fzf ripgrep
```

- `colordiff` — colored diff output
- `grc` — colorizes ping, netstat, etc. (aliases are guarded — safe if missing)
- `hub` — GitHub CLI git wrapper (`alias git='hub'`). Remove if not needed.
- Docker aliases assume user is in the `docker` group — no sudo required:

```bash
sudo usermod -aG docker $USER && newgrp docker
```

### macOS

```bash
brew install bash coreutils colordiff hub vim tmux fzf ripgrep fd bash-completion@2
```

- `bash` — macOS ships with bash 3.2; install bash 5+ for full feature support
- `coreutils` — provides `gls` (GNU ls with `--color`) and `gdircolors` for `.dir_colors`
- After installing bash 5: `chsh -s /opt/homebrew/bin/bash`

### vim plugins

vim-plug auto-installs on first launch. Run `:PlugInstall` once inside Vim if plugins don't load automatically.

### tmux

Requires tmux 3.0+. Optional plugin manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Ansible Deployment (Optional)

For automated deployment across multiple hosts, this repo can be consumed by an Ansible role instead of running the symlink commands manually.

This is useful when provisioning new VMs or homelab nodes where you want dotfiles applied consistently without manual steps.

### Example task
```yaml
- name: Clone dotfiles
  git:
    repo: https://github.com/variablenix/dotfiles.git
    dest: "{{ ansible_env.HOME }}/dotfiles"
    version: main

- name: Deploy common dotfiles
  file:
    src: "{{ ansible_env.HOME }}/dotfiles/common/{{ item }}"
    dest: "{{ ansible_env.HOME }}/{{ item }}"
    state: link
  loop:
    - .gitconfig
    - .gitignore_global
    - .dir_colors
    - .vimrc
    - .tmux.conf

- name: Deploy platform dotfiles
  file:
    src: "{{ ansible_env.HOME }}/dotfiles/{{ ansible_os_family | lower }}/{{ item }}"
    dest: "{{ ansible_env.HOME }}/{{ item }}"
    state: link
  loop:
    - .bashrc
    - .aliases
```

> Uses `ansible_os_family` to select `linux` or `macos` automatically. Add a `vars` block or `when` condition if your family name mapping differs.

## Notes

- `.gitconfig` — name and email are **intentionally blank** — fill in locally or via `~/.bashrc.local`
- `.vimrc` — defaults to `desert` colorscheme (built-in fallback) — swap to your preferred scheme
- `.dir_colors` — Linux uses `dircolors`, macOS uses `gdircolors` (GNU coreutils). Both are handled in the respective `.bashrc`
- WireGuard aliases (Linux only) assume interface `wg0` — adjust if your interface name differs
- Weather aliases default to Las Vegas — change `wttr.in/Las+Vegas` to your city
- macOS `sshagent` alias uses `--apple-use-keychain` to persist the key in the macOS keychain
- `~/.bashrc.local` is sourced automatically if present — use it for anything machine-specific that should never be committed

## Related

Other repos in the [KDN-Cloud](https://github.com/KDN-Cloud) org:

| Repo | Description |
|------|-------------|
| [ops-ref](https://github.com/KDN-Cloud/ops-ref) | Quick-reference sheets for git, vim, bash, docker, and beyond |
| [pi-backups-recovery](https://github.com/KDN-Cloud/pi-backups-recovery) | Bare-metal backup and recovery for Raspberry Pi using raspiBackup |

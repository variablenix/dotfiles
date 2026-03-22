# vim color scheme files

These files are used for the `:colorscheme` command and appear in the **Edit → Color Scheme** menu in the GUI.

---

## Writing a color scheme

There are two basic approaches:

### 1. Define a new Normal color

Set `background` explicitly and build colors from scratch:

```vim
set background={light or dark}
highlight clear
highlight Normal ...
```

### 2. Use the default Normal color

Auto-adjust based on the current value of `background`:

```vim
highlight clear Normal
set background&
highlight clear
if &background == "light"
  highlight Error ...
else
  highlight Error ...
endif
```

---

## Tips

**Resetting to defaults**

Use `:highlight clear` to reset all groups to defaults, then override only what you need. This also handles highlight groups added in future versions of Vim.

> Note: `:highlight clear` uses the current value of `background` — set it before running this command.

**Removing default attributes**

Some attributes (e.g. `bold`) are set by default and may need to be explicitly cleared in your scheme:

```vim
gui=NONE
```

**Setting `background` based on the loaded colorscheme**

```vim
autocmd SourcePre */colors/your_scheme.vim set background=dark
```

Replace `your_scheme` with your colorscheme's filename.

**Tweaking a colorscheme after it loads**

Use the `ColorScheme` autocmd event to apply overrides after any scheme is loaded.

**Finding which highlight group is used where**

See `:help highlight-groups` and `:help group-name`.

**Inspecting current colors**

Use `:highlight` to see active color values. Note: `ctermfg` and `ctermbg` values are terminal-specific numbers — use named colors instead. See `:help cterm-colors`.

**Default color settings**

Found in `src/syntax.c` — search for `highlight_init`.

---

## Checklist before sharing

- [ ] Works in both a color terminal **and** the GUI
- [ ] `g:colors_name` is set to a meaningful value:
  ```vim
  let g:colors_name = expand('<sfile>:t:r')
  ```
- [ ] `background` is either used or explicitly set to `"light"` or `"dark"`
- [ ] Search highlighting is easy to spot (try `:set hlsearch` and search for a pattern)
- [ ] Status lines and vertical separators are clearly visible (test with `:split` and `:vsplit`)
- [ ] Cursor is easy to find in the GUI, even in heavily syntax-highlighted files
- [ ] No hardcoded escape sequences — always use color names or `#RRGGBB` for the GUI

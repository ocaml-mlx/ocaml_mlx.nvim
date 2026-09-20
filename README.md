# ocaml_mlx.nvim

[neovim][] plugin for OCaml's [.mlx][] syntax.

Requires Neovim >= 0.12 and [nvim-treesitter][]'s `main` branch. Neovim 0.11
and nvim-treesitter's legacy `master` branch are not supported: this plugin
no longer registers the parser for `master`.

`:TSInstall ocaml_mlx` builds the parser through nvim-treesitter, so its own
requirements apply — notably the [`tree-sitter` CLI][tree-sitter-cli] (0.26.1
or later, from your package manager rather than npm) and a C compiler.

## Installation

With [vim-plug][] (or your favorite plugin manager):
```vim
Plug 'neovim/nvim-lspconfig'           -- for ocamllsp config
Plug 'nvim-treesitter/nvim-treesitter' -- for treesitter support
Plug 'ocaml-mlx/ocaml_mlx.nvim'
```

Then in `init.lua`:
```lua
require 'ocaml_mlx'
```

Then run `:TSInstall ocaml_mlx` to install the treesitter parser.

## Running the tests

The test suite is [plenary.nvim][]'s busted-style runner, split into two
parts:

- **`make test-fast`** (`test/spec/`) never touches `nvim-treesitter`'s
  installer: `scripts/build_parser.sh` clones [ocaml-mlx/tree-sitter-mlx][]
  (pinned to `master`) and compiles the `ocaml_mlx` and `ocaml` parsers with
  `cc` directly, so tests run against exactly the parser this plugin's
  queries target. This is the fast inner loop for parsing/query/highlight
  assertions.
- **`make test-integration`** (`test/integration/`) drives the *real*
  `:TSInstall ocaml_mlx` command against an actual `nvim-treesitter`
  checkout — this is what a user following the Installation steps above
  actually runs, and it's the only thing that exercises `lua/ocaml_mlx.lua`'s
  `install_info` registration. It's kept separate from `test-fast` because
  it's slower and network-dependent (clones `nvim-treesitter`, and
  `:TSInstall` itself downloads `tree-sitter-mlx`), so a network hiccup here
  never masks a real query regression in the fast suite. Which
  `nvim-treesitter` branch it installs is selected with `TS_BRANCH` (default
  and only supported value: `main`).

```sh
make test-fast          # fast, hermetic
make test-integration   # real :TSInstall, against nvim-treesitter main
make test               # both
```

Both vendor a pinned `plenary.nvim` clone via `scripts/build_parser.sh`.
Everything built or cloned is cached under `test/.build/` (gitignored) so
re-running is fast; `test-integration` additionally isolates itself with its
own `$XDG_DATA_HOME`/`$XDG_STATE_HOME`/`$XDG_CACHE_HOME` under
`test/.build/xdg/` so it never touches your real `nvim-treesitter` install.

Requires `git` and a C compiler (`cc`) on `PATH`. Run `make clean` to wipe
the build cache and force a from-scratch rebuild.

[neovim]: https://neovim.io/
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[.mlx]: https://github.com/ocaml-mlx/mlx
[vim-plug]: https://github.com/junegunn/vim-plug
[ocamlformat-mlx]: https://github.com/ocaml-mlx/ocamlformat-mlx
[plenary.nvim]: https://github.com/nvim-lua/plenary.nvim
[ocaml-mlx/tree-sitter-mlx]: https://github.com/ocaml-mlx/tree-sitter-mlx
[tree-sitter-cli]: https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md

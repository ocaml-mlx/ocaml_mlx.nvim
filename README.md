# ocaml_mlx.nvim

[neovim][] plugin for [mlx][].

## Installation

With [vim-plug][] (or your favorite plugin manager):
```vim
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'ocaml-mlx/ocaml_mlx.nvim'
```

Then in `init.lua` (before lsp setup):
```lua
require 'ocaml_mlx'
```

Then run `:TSInstall ocaml_mlx` to install the treesitter parser.

### Support formatting with `ocamlformat-mlx`

To enable formatting with [ocamlformat-mlx][] (not yet released on opam), install
[stevearc/conform.nvim]:
```vim
Plug 'stevearc/conform.nvim'
```

Then in `init.lua`:
```lua
local conform = require 'conform'

conform.setup {
  formatters_by_ft = {
    ocaml_mlx = {"ocamlformat_mlx"},
  }
}
```

[neovim]: https://neovim.io/
[mlx]: https://github.com/ocaml-mlx/mlx
[vim-plug]: https://github.com/junegunn/vim-plug
[stevearc/conform.nvim]: https://github.com/stevearc/conform.nvim
[ocamlformat-mlx]: https://github.com/ocaml-mlx/ocamlformat-mlx

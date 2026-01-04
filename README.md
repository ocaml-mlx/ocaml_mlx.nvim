# ocaml_mlx.nvim

[neovim][] plugin for OCaml's [.mlx][] syntax.

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

[neovim]: https://neovim.io/
[.mlx]: https://github.com/ocaml-mlx/mlx
[vim-plug]: https://github.com/junegunn/vim-plug
[ocamlformat-mlx]: https://github.com/ocaml-mlx/ocamlformat-mlx

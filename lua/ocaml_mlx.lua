vim.filetype.add {
  extension = {
    mlx = 'ocaml.mlx'
  }
}

vim.treesitter.language.register("ocaml_mlx", "ocaml.mlx")

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    local parsers = require('nvim-treesitter.parsers')
    parsers.ocaml_mlx = {
      install_info = {
        url = "https://github.com/ocaml-mlx/tree-sitter-mlx",
        files = {'src/scanner.c', 'src/parser.c'},
        location = 'grammars/mlx',
        branch = 'master',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'ocaml_mlx',
    }
  end
})

vim.filetype.add {
  extension = {
    mlx = 'ocaml.mlx'
  }
}

vim.treesitter.language.register("ocaml_mlx", "ocaml.mlx")

if vim.fn.has('nvim-0.12') == 0 then
  vim.notify(
    "ocaml_mlx.nvim requires Neovim >= 0.12 (nvim-treesitter's `main` branch requires it); "
      .. "filetype and query registration will still work, but this plugin no longer registers "
      .. "the parser with nvim-treesitter for 0.11's locked `master` branch, so `:TSInstall` won't.",
    vim.log.levels.WARN
  )
end

-- nvim-treesitter `main` discards and reloads the parsers module before each install, so registration must live here, not eagerly at load.
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').ocaml_mlx = {
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
  end,
})

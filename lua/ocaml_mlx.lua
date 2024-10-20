function can_require(module_name)
  local ok,_ = pcall(require, module_name)
  return ok
end

vim.filetype.add {
  extension = {
    mlx = 'ocaml.mlx'
  }
}

vim.treesitter.language.register("ocaml_mlx", "ocaml.mlx")

if can_require 'lspconfig' then
  local lspconfig = require 'lspconfig'
  lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
    if config.name == 'ocamllsp' then
      local filetypes = vim.deepcopy(config.filetypes)
      table.insert(filetypes, 'ocaml.mlx')
      config.filetypes = filetypes

      local get_language_id = config.get_language_id
      function config.get_language_id(bufnr, ft)
        if ft == 'ocaml.mlx' then return 'ocaml'
        else return get_language_id(bufnr, ft) end
      end
    end
  end)
end

if can_require('nvim-treesitter') then
  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.ocaml_mlx = {
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

if can_require('conform') then
  local conform = require 'conform'
  conform.formatters.ocamlformat_mlx = {
    inherit = false,
    command = 'ocamlformat-mlx',
    args = { '--name', '$FILENAME', '--impl', '-' },
    stdin = true,
  }
end

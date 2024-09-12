vim.filetype.add { extension = { mlx = 'ocaml_mlx' } }

function can_require(module_name)
  local ok,_ = pcall(require, module_name)
  return ok
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

if can_require('lspconfig') then
local lspconfig = require 'lspconfig'

local ocamllsp_config = lspconfig.ocamllsp.document_config.default_config
table.insert(ocamllsp_config.filetypes, 'ocaml_mlx')

local get_language_id = ocamllsp_config.get_language_id

function ocamllsp_config.get_language_id(bufnr, ftype)
  if ftype == 'ocaml_mlx' then 
    return 'ocaml' 
  else 
    return get_language_id(bufnr, ftype)
  end
end
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

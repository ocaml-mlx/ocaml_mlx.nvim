vim.filetype.add { extension = { mlx = 'ocaml_mlx' } }

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

local lspconfig = require('lspconfig')

local ocamllsp_config = lspconfig.ocamllsp.document_config.default_config
table.insert(ocamllsp_config.filetypes, 'ocaml_mlx')

function ocamllsp_config.get_language_id(bufnr, ftype)
  if ftype == 'ocaml_mlx' then 
    return 'ocaml' 
  else 
    return ocamllsp_config.get_language_id(bufnr, ftype)
  end
end

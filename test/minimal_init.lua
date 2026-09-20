-- Bootstrap for `make test-fast`; plenary spawns this once per spec file.
local root = vim.fn.getcwd()
local build = root .. "/test/.build"

vim.opt.runtimepath:prepend(root)
vim.opt.runtimepath:prepend(build .. "/plenary.nvim")
vim.opt.runtimepath:append(build .. "/runtime")

package.path = root .. "/test/?.lua;" .. package.path

vim.cmd("runtime! plugin/plenary.vim")

local add_language = require("helpers").add_language

local parser_dir = build .. "/parser"
local ok_mlx, err_mlx = pcall(add_language, "ocaml_mlx", parser_dir .. "/ocaml_mlx.so")
local ok_ocaml, err_ocaml = pcall(add_language, "ocaml", parser_dir .. "/ocaml.so")

if not ok_mlx or not ok_ocaml then
  io.stderr:write(
    "Failed to load hermetic parsers from "
      .. parser_dir
      .. ". Did you run `make build-parser` (or `scripts/build_parser.sh`)?\n"
  )
  io.stderr:write(tostring(err_mlx) .. "\n" .. tostring(err_ocaml) .. "\n")
  os.exit(1)
end

require("ocaml_mlx")

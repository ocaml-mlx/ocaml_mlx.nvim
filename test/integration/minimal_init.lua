-- Puts a real nvim-treesitter checkout on the runtimepath and drives `:TSInstall ocaml_mlx`; expects it already cloned by scripts/fetch_nvim_treesitter.sh, and XDG_*_HOME isolation set by `make test-integration`.
local function log(msg)
  io.stderr:write("[integration] " .. msg .. "\n")
end

log("starting minimal_init.lua")

local root = vim.fn.getcwd()
local build = root .. "/test/.build"
local ts_branch = vim.env.TS_BRANCH or "main"
local nvt_dir = build .. "/nvim-treesitter-" .. ts_branch
local plenary_dir = build .. "/plenary.nvim"

assert(
  vim.fn.isdirectory(nvt_dir .. "/.git") == 1,
  "expected an nvim-treesitter (" .. ts_branch .. ") clone at " .. nvt_dir
    .. "; run `scripts/fetch_nvim_treesitter.sh " .. ts_branch .. "` (or `make test-integration`)"
)
log("using nvim-treesitter (" .. ts_branch .. ") clone at " .. nvt_dir)

assert(
  vim.fn.isdirectory(plenary_dir .. "/.git") == 1,
  "plenary.nvim not found at " .. plenary_dir .. "; run `make build-parser` (or `make test-integration`)"
)
log("using plenary.nvim clone at " .. plenary_dir)

vim.opt.runtimepath:prepend(root)
vim.opt.runtimepath:prepend(nvt_dir)
vim.opt.runtimepath:prepend(plenary_dir)

package.path = root .. "/test/?.lua;" .. package.path

vim.cmd("runtime! plugin/nvim-treesitter.lua")
vim.cmd("runtime! plugin/plenary.vim")

require('nvim-treesitter').setup {}

log("requiring ocaml_mlx plugin")
require("ocaml_mlx")
log("minimal_init.lua done; handing off to test spec(s)")

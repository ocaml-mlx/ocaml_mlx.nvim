-- Loadable via `require("helpers")` once minimal_init.lua has put test/ on package.path (Neovim's own package.path only covers <rtp>/lua/?.lua).
local M = {}

function M.parse(src)
  local parser = vim.treesitter.get_string_parser(src, "ocaml_mlx")
  return parser:parse()[1]:root()
end

function M.read_fixture(name)
  local path = vim.fn.getcwd() .. "/test/fixtures/" .. name
  local f = assert(io.open(path, "r"))
  local content = f:read("*a")
  f:close()
  return content
end

function M.count_capture(captures, name, text)
  local n = 0
  for _, c in ipairs(captures) do
    if c[1] == name and (text == nil or c[2] == text) then
      n = n + 1
    end
  end
  return n
end

-- assert() turns a `nil, err` return from vim.treesitter.language.add() into a thrown error.
function M.add_language(lang, path)
  return assert(vim.treesitter.language.add(lang, { path = path }))
end

-- Opens `lines` as a temporary *.mlx buffer; the returned cleanup function must run even if the caller's own assertions fail.
function M.open_mlx_buffer(lines)
  local tmp = vim.fn.tempname() .. ".mlx"
  vim.fn.writefile(lines, tmp)
  vim.cmd("edit " .. vim.fn.fnameescape(tmp))
  return function()
    vim.cmd("bwipeout!")
    vim.fn.delete(tmp)
  end
end

return M

local helpers = require("helpers")
local open_mlx_buffer, add_language = helpers.open_mlx_buffer, helpers.add_language

-- `main` installs into stdpath('data')/site/parser.
local function find_installed_parser()
  local candidates = {
    vim.fs.joinpath(vim.fn.stdpath("data"), "site", "parser", "ocaml_mlx.so"),
  }
  for _, path in ipairs(vim.opt.runtimepath:get()) do
    if path:match("nvim%-treesitter") then
      table.insert(candidates, vim.fs.joinpath(path, "parser", "ocaml_mlx.so"))
    end
  end

  local found
  local ok = vim.wait(120000, function()
    for _, candidate in ipairs(candidates) do
      if vim.uv.fs_stat(candidate) then
        found = candidate
        return true
      end
    end
    return false
  end, 300)

  return found, ok, candidates
end

describe(":TSInstall ocaml_mlx (real nvim-treesitter, branch " .. (vim.env.TS_BRANCH or "main") .. ")", function()
  -- Runs once at describe-collection time (before any `it`); both below reuse its result.
  vim.cmd("TSInstall ocaml_mlx")
  local found, ok, candidates = find_installed_parser()
  assert.is_true(
    ok,
    "timed out waiting for ocaml_mlx.so; looked in:\n  " .. table.concat(candidates, "\n  ")
  )
  add_language("ocaml_mlx", found)

  it("installs a working ocaml_mlx parser", function()
    -- Confirms nvim-treesitter fetched the whole tree-sitter-mlx repo (not just grammars/mlx), so scanner.c's ../../../common/scanner.h include resolved.
    local tree = vim.treesitter.get_string_parser("let x = <div a=1>x</div>", "ocaml_mlx"):parse()[1]
    assert.is_false(tree:root():has_error())
  end)

  it("resolves the ocaml_mlx parser for an ocaml.mlx buffer end-to-end", function()
    local cleanup = open_mlx_buffer({ "let x = <div />" })
    local ok, err = pcall(function()
      assert.are.same("ocaml.mlx", vim.bo.filetype)

      local parser = vim.treesitter.get_parser(0)
      assert.are.same("ocaml_mlx", parser:lang())
    end)
    cleanup()
    assert(ok, err)
  end)
end)

local eq = assert.are.same
local open_mlx_buffer = require("helpers").open_mlx_buffer

describe("ocaml_mlx filetype/parser wiring", function()
  it("resolves *.mlx -> filetype ocaml.mlx -> language ocaml_mlx end-to-end", function()
    local cleanup = open_mlx_buffer({ "let x = <div />" })
    local ok, err = pcall(function()
      eq("ocaml.mlx", vim.bo.filetype)

      eq("ocaml_mlx", vim.treesitter.language.get_lang("ocaml.mlx"))

      -- One chain, not three tests: this assertion could fail from either of the above breaking; they narrow down which.
      local parser = vim.treesitter.get_parser(0)
      eq("ocaml_mlx", parser:lang())
    end)
    cleanup()
    assert(ok, err)
  end)
end)

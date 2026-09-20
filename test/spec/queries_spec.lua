-- Plenary's harness injects `set rtp+=.` after `-u`, duplicating this repo on the runtimepath and doubling every capture; remove it here.
vim.opt.runtimepath:remove(".")

local helpers = require("helpers")
local parse, count_capture = helpers.parse, helpers.count_capture

-- Collects {capture_name, text} pairs for every match of `query_name` ("highlights" or "indents") over `src`.
local function run_query(query_name, src)
  local root = parse(src)
  local q = vim.treesitter.query.get("ocaml_mlx", query_name)
  local out = {}
  for id, node in q:iter_captures(root, src, 0, -1) do
    local name = q.captures[id]
    table.insert(out, { name, vim.treesitter.get_node_text(node, src) })
  end
  return out
end

local function has_capture(captures, name, text)
  return count_capture(captures, name, text) > 0
end

describe("ocaml_mlx queries", function()
  it("compiles highlights.scm and actually resolves `; inherits: ocaml`", function()
    local q = vim.treesitter.query.get("ocaml_mlx", "highlights")
    assert.is_not_nil(q)
    -- `@keyword` only exists in the base ocaml query, so seeing it fire proves `; inherits: ocaml` actually resolved.
    --
    -- Caveat: inherits from tree-sitter-mlx's vendored ocaml highlights.scm, not nvim-treesitter's bundled one -- similar but not guaranteed identical.
    local captures = run_query("highlights", "let _ = <div />")
    assert.is_true(has_capture(captures, "keyword", "let"))
  end)

  it("compiles indents.scm on its own (mlx-only body; `; inherits: ocaml` NOT exercised)", function()
    -- indents.scm isn't in tree-sitter-mlx's vendored queries/ (it's an nvim-treesitter artifact), so inheritance isn't tested hermetically here.
    local q = vim.treesitter.query.get("ocaml_mlx", "indents")
    assert.is_not_nil(q)
  end)

  describe("highlight captures", function()
    it("puts @tag.builtin on lowercase (value_name) tags", function()
      local captures = run_query("highlights", "let _ = <div a=1>x</div>")
      assert.is_true(has_capture(captures, "tag.builtin", "div"))
    end)

    it("puts @tag.attribute on prop names", function()
      local captures = run_query("highlights", "let _ = <div a=1>x</div>")
      assert.is_true(has_capture(captures, "tag.attribute", "a"))
    end)

    it("puts @tag.delimiter on <, >, </ and />", function()
      local opening = run_query("highlights", "let _ = <div a=1>x</div>")
      assert.is_true(has_capture(opening, "tag.delimiter", "<"))
      assert.is_true(has_capture(opening, "tag.delimiter", ">"))
      assert.is_true(has_capture(opening, "tag.delimiter", "</"))

      local self_closing = run_query("highlights", "let _ = <div />")
      assert.is_true(has_capture(self_closing, "tag.delimiter", "<"))
      assert.is_true(has_capture(self_closing, "tag.delimiter", "/>"))
    end)

    it("puts @punctuation.special on the children-spread `...`", function()
      local captures = run_query("highlights", "let _ = <ul>...items</ul>")
      assert.is_true(has_capture(captures, "punctuation.special", "..."))
    end)

    it("also captures the spread's `...` when spaced", function()
      local captures = run_query("highlights", "let _ = <ul> ...items </ul>")
      assert.is_true(has_capture(captures, "punctuation.special", "..."))
    end)

    it("captures land correctly across the full sample fixture", function()
      local captures = run_query("highlights", helpers.read_fixture("sample.mlx"))

      assert.is_true(count_capture(captures, "tag.builtin") > 0)

      -- sample.mlx has three `...` children spreads.
      assert.are.equal(3, count_capture(captures, "punctuation.special", "..."))
    end)

    describe("known gaps (asserted as current behaviour, not fixed)", function()
      it("does NOT put @tag.builtin anywhere in a module-path tag like <Foo.Bar />", function()
        -- highlights.scm only matches (jsx_tag (value_name)); module-path tags fall through entirely -- a known gap, asserted here as current behaviour, not a bug.
        local captures = run_query("highlights", "let _ = <Foo.Bar />")
        for _, c in ipairs(captures) do
          assert.are_not.equal("tag.builtin", c[1])
        end
      end)
    end)
  end)
end)

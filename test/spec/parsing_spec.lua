local helpers = require("helpers")

-- root:has_error() covers this in one call; walking explicitly reports *where* a problem is.
local function assert_no_error_nodes(node, src, path)
  path = path or node:type()
  if node:type() == "ERROR" then
    error(("ERROR node at %s: %q"):format(path, vim.treesitter.get_node_text(node, src)))
  end
  if node:missing() then
    error(("MISSING node at %s"):format(path))
  end
  for i = 0, node:named_child_count() - 1 do
    local child = node:named_child(i)
    assert_no_error_nodes(child, src, path .. " > " .. child:type())
  end
end

describe("ocaml_mlx parsing", function()
  it("parses the sample fixture with zero ERROR/MISSING nodes", function()
    local src = helpers.read_fixture("sample.mlx")
    local root = helpers.parse(src)

    assert.is_false(root:has_error())
    assert_no_error_nodes(root, src)
  end)

  -- One assertion per construct, so a regression points at exactly what broke.
  local cases = {
    { "self-closing element", "let _ = <div />" },
    { "element with children", "let _ = <div>x</div>" },
    { "module-path self-closing tag", "let _ = <Foo.Bar />" },
    { "module-path tag with children", "let _ = <Foo.Bar>x</Foo.Bar>" },
    { "valued prop", "let _ = <div a=1 />" },
    { "string-valued prop", 'let _ = <div a="x" />' },
    { "punned prop", "let _ = <div attr />" },
    { "optional punned prop", "let _ = <div ?opt />" },
    { "optional valued prop", "let _ = <div ?opt=v />" },
    { "mixed prop forms", "let _ = <div attr with_value=1 ?opt ?opt_value=v />" },
    { "nested elements", "let _ = <div><span>a</span></div>" },
    { "children spread, unspaced", "let _ = <div>...children</div>" },
    { "children spread, spaced", "let _ = <div> ...children </div>" },
    { "children spread of a nested element", "let _ = <div>...<span>a</span></div>" },
  }

  for _, case in ipairs(cases) do
    local name, src = case[1], case[2]
    it(("parses %s with no errors"):format(name), function()
      local root = helpers.parse(src)
      assert.is_false(root:has_error())
    end)
  end
end)

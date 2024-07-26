; inherits: ocaml
; extends

(jsx_prop
  (jsx_prop_name) @tag.attribute)

(jsx_element_opening
  name: (value_path (value_name)) @tag.builtin)

(jsx_element_closing
  name: (value_path (value_name)) @tag.builtin)

(jsx_element_self_closing
  name: (value_path (value_name)) @tag.builtin)

(jsx_expression
  (jsx_element_opening
    [
      "<"
      ">"
    ] @tag.delimiter))

(jsx_expression
  (jsx_element_closing
    [
      "</"
      ">"
    ] @tag.delimiter))

(jsx_expression
  (jsx_element_self_closing
    [
      "<"
      "/>"
    ] @tag.delimiter))


#!/usr/bin/env bash
# scanner.c includes ../../../common/scanner.h, so the whole tree-sitter-mlx repo is cloned, not just grammars/mlx.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/lib.sh"

BUILD="$ROOT/test/.build"
SRC="$BUILD/tree-sitter-mlx"
PARSER_DIR="$BUILD/parser"
RUNTIME_QUERIES="$BUILD/runtime/queries/ocaml"
PLENARY_DIR="$BUILD/plenary.nvim"

mkdir -p "$BUILD" "$PARSER_DIR"

clone_or_reuse "https://github.com/ocaml-mlx/tree-sitter-mlx.git" "$SRC" "master" "tree-sitter-mlx"
clone_or_reuse "https://github.com/nvim-lua/plenary.nvim.git" "$PLENARY_DIR" "" "plenary.nvim"

build_parser() {
  local name="$1" src_dir="$2"
  local out="$PARSER_DIR/$name.so"
  if [ -f "$out" ]; then
    echo "==> $name.so up to date"
  else
    echo "==> Building $name.so"
    cc -fPIC -shared -Os -I "$src_dir" "$src_dir/parser.c" "$src_dir/scanner.c" -o "$out"
  fi
}

build_parser "ocaml_mlx" "$SRC/grammars/mlx/src"
build_parser "ocaml" "$SRC/grammars/ocaml/src"

# Vendors tree-sitter-mlx's own highlights.scm (shared across its four grammars, per tree-sitter.json) so `; inherits: ocaml` resolves without nvim-treesitter.
mkdir -p "$RUNTIME_QUERIES"
cp "$SRC/queries/highlights.scm" "$RUNTIME_QUERIES/highlights.scm"

echo "==> Ready: $PARSER_DIR/ocaml_mlx.so, $PARSER_DIR/ocaml.so"

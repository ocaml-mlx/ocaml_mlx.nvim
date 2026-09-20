#!/usr/bin/env bash
# Must run outside plenary's per-spec-file timeout -- cloning there fails as a bare "Error 1" with no diagnostics.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/lib.sh"

BUILD="$ROOT/test/.build"

TS_BRANCH="${1:-${TS_BRANCH:-main}}"
NVT_DIR="$BUILD/nvim-treesitter-$TS_BRANCH"

mkdir -p "$BUILD"

clone_or_reuse "https://github.com/nvim-treesitter/nvim-treesitter.git" "$NVT_DIR" "$TS_BRANCH" "nvim-treesitter ($TS_BRANCH)"

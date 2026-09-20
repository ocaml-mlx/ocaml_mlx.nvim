# Source, don't execute: `source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"`.

# clone_or_reuse REPO DIR [BRANCH] [LABEL]
clone_or_reuse() {
  local repo="$1" dir="$2" branch="${3:-}" label="${4:-$(basename "$2")}"

  if [ -d "$dir/.git" ]; then
    echo "==> Using cached $label clone at $dir ($(git -C "$dir" rev-parse --short HEAD))"
  else
    echo "==> Cloning $label..."
    if [ -n "$branch" ]; then
      git clone --depth 1 --branch "$branch" "$repo" "$dir"
    else
      git clone --depth 1 "$repo" "$dir"
    fi
    echo "==> Cloned $label to $dir ($(git -C "$dir" rev-parse --short HEAD))"
  fi
}

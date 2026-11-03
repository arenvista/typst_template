#!/bin/sh
# Install this directory as a Typst local package, so that any document on
# the machine can reach it with
#
#     #import "@local/<name>:<version>": *
#
#   ./install.sh           link it (edits here apply immediately) — default
#   ./install.sh --copy    copy it (a frozen snapshot)
#   ./install.sh --force   replace an install that is already there
#   ./install.sh --skill   also install the Claude Code skill, for every project
#
# The name, version and entrypoint all come from typst.toml; change them
# there and re-run this, rather than editing paths by hand.
set -eu

src=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
field() { sed -n "s/^$1 *= *\"\\(.*\\)\"/\\1/p" "$src/typst.toml" | head -1; }

name=$(field name)
version=$(field version)
[ -n "$name" ] && [ -n "$version" ] || { echo "typst.toml: no name/version" >&2; exit 1; }

# Where Typst looks for local packages, per platform.
case "$(uname -s)" in
  Darwin) data="$HOME/Library/Application Support/typst" ;;
  *)      data="${XDG_DATA_HOME:-$HOME/.local/share}/typst" ;;
esac
dest="$data/packages/local/$name/$version"

mode=link
force=0
skill=0
for arg in "$@"; do
  case "$arg" in
    --copy) mode=copy ;;
    --link) mode=link ;;
    --force|-f) force=1 ;;
    --skill) skill=1 ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

if [ -e "$dest" ] || [ -L "$dest" ]; then
  if [ "$force" -eq 1 ]; then
    rm -rf -- "$dest"
  else
    echo "already installed at $dest" >&2
    echo "re-run with --force to replace it" >&2
    exit 1
  fi
fi

mkdir -p -- "$(dirname -- "$dest")"
if [ "$mode" = link ]; then
  ln -s -- "$src" "$dest"
else
  mkdir -p -- "$dest"
  # The entrypoint, the manifest and the starter template are all a package
  # needs; the source documents beside them are not part of it.
  cp -- "$src/typst.toml" "$(field entrypoint | sed "s|^|$src/|")" "$dest/"
  [ -d "$src/template" ] && cp -R -- "$src/template" "$dest/"
fi

printf '%s %s:%s\n  -> %s\n' \
  "$([ "$mode" = link ] && echo linked || echo copied)" \
  "$name" "$version" "$dest"

# The Claude Code skill: user-level, so it is available in every project.
# For one project only, link it into that project's .claude/skills instead.
if [ "$skill" -eq 1 ]; then
  sdest="$HOME/.claude/skills/$name"
  if [ -e "$sdest" ] || [ -L "$sdest" ]; then
    if [ "$force" -eq 1 ]; then
      rm -rf -- "$sdest"
    else
      echo "skill already at $sdest — re-run with --force to replace it" >&2
      exit 1
    fi
  fi
  mkdir -p -- "$(dirname -- "$sdest")"
  if [ "$mode" = link ]; then
    ln -s -- "$src/skills/$name" "$sdest"
  else
    mkdir -p -- "$sdest"
    cp -- "$src/skills/$name/SKILL.md" "$sdest/"
  fi
  printf 'skill\n  -> %s\n' "$sdest"
fi

printf '\nUse it with:\n  #import "@local/%s:%s": *\n' "$name" "$version"

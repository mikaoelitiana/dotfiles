#!/bin/bash

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(printf '%s' "$input" | jq -r '.model.display_name')
git_worktree=$(printf '%s' "$input" | jq -r '.workspace.git_worktree // .worktree.name // empty')
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
if [ -z "$branch" ]; then
  short_sha=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  [ -n "$short_sha" ] && branch="detached@$short_sha"
fi
[ -z "$branch" ] && branch="no-git"

if [ -n "$git_worktree" ]; then
  worktree="$git_worktree"
else
  git_dir=$(git -C "$cwd" --no-optional-locks rev-parse --git-dir 2>/dev/null)
  common_dir=$(git -C "$cwd" --no-optional-locks rev-parse --git-common-dir 2>/dev/null)
  if [ -n "$git_dir" ] && [ -n "$common_dir" ] && [ "$git_dir" != "$common_dir" ]; then
    toplevel=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
    worktree=$(basename "$toplevel")
  elif [ -n "$common_dir" ]; then
    worktree="main"
  else
    worktree="no-git"
  fi
fi

if [ -n "$used_pct" ]; then
  context=$(printf '%.0f%%' "$used_pct")
else
  context="—"
fi

middle_truncate() {
  local text="$1" max="$2" len head_len tail_len
  len=${#text}
  if [ "$len" -le "$max" ]; then
    printf '%s' "$text"
    return
  fi
  head_len=$(( (max - 1) / 2 ))
  tail_len=$(( max - 1 - head_len ))
  printf '%s…%s' "${text:0:head_len}" "${text:len-tail_len}"
}

branch=$(middle_truncate "$branch" 60)
worktree=$(middle_truncate "$worktree" 40)

RESET="\033[0m"
CYAN="\033[36m"
GREEN="\033[32m"
MAGENTA="\033[35m"
YELLOW="\033[33m"
DIM="\033[2m"

printf "${DIM}${YELLOW}▤ %s${RESET} ${DIM}${MAGENTA}✨ %s${RESET}\n" "$context" "$model"
printf "${DIM}${CYAN}⎇ %s${RESET} ${DIM}${GREEN}⎔ %s${RESET}\n" "$branch" "$worktree"

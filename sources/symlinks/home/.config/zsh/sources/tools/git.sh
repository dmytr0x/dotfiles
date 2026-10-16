alias gst='
  git status --short --branch
  printf "Unstaged: %s\n" "$(git diff --shortstat)"
  printf "Staged:   %s\n" "$(git diff --staged --shortstat HEAD)"
'

# Git Switch
gsw() {
  local branch

  branch=$(
    git for-each-ref \
      --sort=-committerdate \
      --format='%(refname:short)' refs/heads |
      fzf --no-sort \
        --preview 'git log -10 --oneline --color=always {} --'
  ) || return

  [[ -n "$branch" ]] && git switch -- "$branch"
}

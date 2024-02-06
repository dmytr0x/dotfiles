function source_exists() {
  file=$1
  [ -f "$file" ] && source "$file"
}

function add_path() {
  new_path=$1
  if [[ "$PATH" != *$new_path* ]]; then
    export PATH="$PATH:$new_path"
  fi
}

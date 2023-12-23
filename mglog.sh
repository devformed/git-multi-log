usage() {
    cat << EOF >&2

Usage: mglog [options] [<command>]

Commands:
 log                                    Prints commits history among all
                                        tracked repositories
 set                                    Set current options as default
 cfg                                    Prints current configuration

Options:
 -r, --repo <path string>               Paths to git repositories
                                        separated by commas
 -a, --author <name string>             Author names to filter by,
                                        separated bby commans
Example:
 mglog -a "Anton Gorokh" -r "/path/to/repo" set; mglog log
EOF
}

#CFG_PATH=/usr/local/etc/mglog.cfg
CFG_PATH=./mglog.cfg
REPOS=
AUTHORS=

print_cfg() {
  echo "CFG_PATH=$CFG_PATH"
  echo "REPOS=$REPOS"
  echo "AUTHORS=$AUTHORS"
}

write_cfg() {
  echo "REPOS=$REPOS" > "$CFG_PATH"
  echo "AUTHORS=$AUTHORS" >> "$CFG_PATH"
}

add_argument() {
  if [ $# -ne 2 ]; then
    echo "Fatal error during argument \"$1\" setting"
    exit 0
  fi

  local key="$1"
  local value="${!key}"
  eval $key="'$value,$2'"
}

set_argument() {
  if [ $# -ne 2 ]; then
    echo "Fatal error during argument \"$1\" adding"
    exit 0
  fi

  eval $1="'$2'"
}

read_cfg() {
  if [ ! -f "$CFG_PATH" ]; then
    return;
  fi

  while IFS= read -r line; do
      # Skip empty lines and lines starting with '#'
      if [[ -z "$line" || $line == \#* ]]; then
          continue
      fi

      local key=$(echo $line | cut -d'=' -f1)
      local value=$(echo $line | cut -d'=' -f2)

      set_argument "$key" "$value"
  done < "$CFG_PATH"
}

error_usage() {
  echo "Unknown command or option \"$1\", usage: mglog --help"
  exit 0
}

print_log() {
  git log --all --decorate --pretty=format:"%h %ad %an - %s %ar %d" --date=format:"%Y-%m-%d %H:%M:%S";
}

resolve_argument() {
  case "$1" in
      "--help")
        usage
        exit 1
        ;;
      "-a")
        set_argument "AUTHORS" "$2"
        ;;
      "--author")
        set_argument "AUTHORS" "$2"
        ;;
      "-r")
        set_argument "REPOS" "$2"
        ;;
      "--repo")
        set_argument "REPOS" "$2"
        ;;
      *)
        error_usage "$1"
        ;;
  esac
}

if [[ $# < 1 ]]; then
  usage
fi

read_cfg

while [ -n "$1" ]; do
  if [[ "$1" == -* ]]; then
    resolve_argument "$1" "$2"
    shift 2
    continue
  fi

  case "$1" in
    "log")
      echo not implemented
      ;;
    "set")
      write_cfg
      ;;
    "cfg")
      print_cfg
      ;;
    *)
      error_usage "$1"
      ;;
  esac

  shift
done
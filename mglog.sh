usage() {
    cat << EOF >&2

Usage: mglog [options] [<command>]

Commands:
 log                                    Prints commits history among all
                                        tracked repositories
 add <path string>                      Adds new tracked git repository
 set <option> <arg>                     Set option value as default

Options:
 -b, --branch <name string>             Filter by branch name(-s). Args
                                        separated by commas
 -a, --author <name string>             Filter by author name(-s). Args
                                        separated by commas
Example: mglog -a "Anton Gorokh" log

EOF
}

error_usage() {
  echo "Unknown command or option \"$1\", usage: mglog --help"
}

BRANCHES=master,main
AUTHORS=

add_argument() {
  case "$1" in
      "--help")
        usage
        exit 1
        ;;
      "-a")
        echo "author $2"
        ;;
      "--author")
        echo "author $2"
        ;;
      "-b")
        echo "branch $2"
        ;;
      "--branch")
        echo "branch $2"
        ;;
      *)
        error_usage $1
        ;;
  esac
}

if [[ $# < 1 ]]; then
  usage
fi

while [ -n "$1" ]; do
  if [[ "$1" == -* ]]; then
    add_argument $1 $2
    shift 2
    continue
  fi

  case "$1" in
    "log")
      echo not implemented
      ;;
    "add")
      echo not implemented
      ;;
    "set")
      echo not implemented
      ;;
    *)
      error_usage $1
      ;;
  esac

  shift
done
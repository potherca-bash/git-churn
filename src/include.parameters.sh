    # shellcheck disable=SC2039
    local -a aParameters=()
    local sArgument

    # /dev/stdin is a symlink to /proc/self/fd/0 but more readable
    if [ -p /dev/stdin ]; then
        # Input was piped in, read pipe
        while read -r sArgument; do
            aParameters+=("${sArgument}")
        done < /dev/stdin
    fi

    if [ "$*" != '' ];then
      for sArgument in "$@";do
          aParameters+=( "${sArgument}" )
      done
    fi

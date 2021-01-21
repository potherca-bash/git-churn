#!/usr/bin/env bash

file_line_count() {
    # shellcheck disable=SC2002
    cat "${1?One parameter required: <file-path>}" | wc -l
}

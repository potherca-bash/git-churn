#!/usr/bin/env bash

file_size() {
    du -b "${1?One parameter required: <file-path>}" | cut -f1
}

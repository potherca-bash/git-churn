#!/usr/bin/env bash

git_file_changes() {
    local sFile sRepoPath

    readonly sRepoPath=${1?Two parameters required: <repo-path> <file>}
    readonly sFile=${2?Two parameters required: <repo-path> <file>}

    git -C "${sRepoPath}" log --numstat --oneline -- "${sFile}" \
        | grep -E "[0-9-]+\s[0-9-]+\s${sFile}" \
        | cut -f1,2 \
        | awk '{inserted+=$1;deleted+=$2} END{print inserted" " deleted;}'
}

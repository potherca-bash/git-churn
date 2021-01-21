#!/usr/bin/env bash

git_file_commits() {
    local sFile sRepoPath

    readonly sRepoPath="${1?Two parameters required: <repo-path> <file>}"
    readonly sFile="${2?Two parameters required: <repo-path> <file>}"

    git -C "${sRepoPath}" log --oneline -- "${sFile}" | wc -l
}

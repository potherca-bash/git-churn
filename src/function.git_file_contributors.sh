#!/usr/bin/env bash

git_file_contributors() {
    local sContributors sFile sRepoPath

    readonly sRepoPath="${1?Two parameters required: <repo-path> <file>}"
    readonly sFile="${2?Two parameters required: <repo-path> <file>}"

    # @FIXME: For some unknown reason, when `git_churn` is called with a pipe, output here is empty!
    #         The `git shortlog` call might need to be replaced with a `git log` call to fix this...
    readonly sContributors="$(git -C "${sRepoPath}" shortlog -ens -- "${sFile}" \
        | sed --regexp-extended 's/^\s+([0-9]+)\s([^<]+) <([^>]+)>/{"commits":"\1","email":"\3","name":"\2"}/g' \
        | tr "\n" ','
    )"

    # Remove trailing comma
    echo "${sContributors%?}"
}

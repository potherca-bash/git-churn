#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail

git_churn() {
    source './src/function.file_line_count.sh'
    source './src/function.file_size.sh'
    source './src/function.git_file_changes.sh'
    source './src/function.git_file_commits.sh'
    source './src/function.git_file_contributors.sh'

    # @TODO: Support pipes

    local sChanges sFilePath sFileList sRepoPath

    readonly sRepoPath="${1?One parameter required: <path-to-repository>}"

    # @TODO: Support remote repositories

    readonly sFileList="$(git -C "${sRepoPath}" ls-tree -r --name-only HEAD)"

    echo '['

    for sFile in ${sFileList}; do
        sFilePath="${sRepoPath}/${sFile}"

        sChanges="$(git_file_changes "${sRepoPath}" "${sFile}")"

        # Modifying a line is represented as 1 insertion and 1 deletion
        printf '  {"file":"%s", "size":"%s", "lines":"%s", "commits":%s, "inserted":%s, "deleted":%s, "contributors":[%s]},\n' \
          "${sFile}"\
          "$(file_size "${sFilePath}")"\
          "$(file_line_count "${sFilePath}")" \
          "$(git_file_commits "${sRepoPath}" "${sFile}")" \
          "${sChanges%% *}" \
          "${sChanges#* }" \
          "$(git_file_contributors "${sRepoPath}" "${sFile}")"
    done

    echo ']'
}

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    export -f git_churn
else
    git_churn "${@-}"
    exit ${?}
fi
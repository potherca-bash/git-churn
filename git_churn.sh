#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail

git_churn() {
    source './src/function.file_line_count.sh'
    source './src/function.file_size.sh'
    source './src/function.git_file_changes.sh'
    source './src/function.git_file_commits.sh'
    source './src/function.git_file_contributors.sh'

    source './src/include.parameters.sh'

    local sChanges sFilePath sFileList sLastFile sRepoPath sTemporaryDirectory

    sRepoPath="${aParameters[0]?One parameter required: <path-to-repository>}"

    if echo "${sRepoPath}" | grep -qE '^([a-z]+s?://)|(\w+@[^.]+\.[^./:]+:)'; then
        readonly sTemporaryDirectory="$(mktemp -d)"

        trap "{ rm -rdf ""${sTemporaryDirectory}""; }" SIGINT SIGTERM ERR EXIT

        git clone --depth 1 --no-tags --quiet "${sRepoPath}" "${sTemporaryDirectory}"

        sRepoPath="${sTemporaryDirectory}"
    fi

    readonly sFileList="$(git -C "${sRepoPath}" ls-tree -r --name-only HEAD)"

    readonly sLastFile="$(echo "${sFileList}" | tail -n1)"

    echo -n '['

    for sFile in ${sFileList}; do
        sFilePath="${sRepoPath}/${sFile}"

        sChanges="$(git_file_changes "${sRepoPath}" "${sFile}")"

        # Modifying a line is represented as 1 insertion and 1 deletion
        printf '\n  {"file":"%s", "size":"%s", "lines":"%s", "commits":%s, "inserted":%s, "deleted":%s, "contributors":[%s]}' \
          "${sFile}"\
          "$(file_size "${sFilePath}")"\
          "$(file_line_count "${sFilePath}")" \
          "$(git_file_commits "${sRepoPath}" "${sFile}")" \
          "${sChanges%% *}" \
          "${sChanges#* }" \
          "$(git_file_contributors "${sRepoPath}" "${sFile}")"

          if [[ "${sFile}" != "${sLastFile}" ]]; then
              echo -n ','
          fi
    done

    echo -e '\n]'
}

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    export -f git_churn
else
    git_churn "${@-}"
    exit ${?}
fi

# Git churn

JSON representation of the churn for a given git repository

## Installation

The advised installation method is using the [`bpkg` package manager][bpkg], as
this will allow versioning to be used:

```sh
bpkg install potherca-bash/git-churn@v0.1.0
```

Alternatively, the latest version of this project's main script can be
downloaded directly:

```sh
curl -Lo- https://bpkg.pother.ca/inline-source/dist/git_churn
chmod +x git-churn
```

## Usage

This script will output JSON containing information regarding a given repository
path or URL.

For instance, called on this repository:

```sh
git_churn /path/to/git-churn
```

It will output something like:

```json
[
  {"file":"LICENSE", "size":"16725", "lines":"373", "commits":1, "inserted":373, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"README.md", "size":"3640", "lines":"92", "commits":1, "inserted":92, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"bpkg.json", "size":"696", "lines":"25", "commits":1, "inserted":25, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"dist/git_churn", "size":"3637", "lines":"115", "commits":1, "inserted":115, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"git_churn.sh", "size":"2249", "lines":"63", "commits":3, "inserted":61, "deleted":5, "contributors":[{"commits":"3","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"src/function.file_line_count.sh", "size":"134", "lines":"6", "commits":1, "inserted":6, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"src/function.file_size.sh", "size":"100", "lines":"5", "commits":1, "inserted":5, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"src/function.git_file_changes.sh", "size":"424", "lines":"13", "commits":1, "inserted":13, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"src/function.git_file_commits.sh", "size":"278", "lines":"10", "commits":1, "inserted":10, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"src/function.git_file_contributors.sh", "size":"721", "lines":"18", "commits":1, "inserted":18, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
  {"file":"src/include.parameters.sh", "size":"449", "lines":"17", "commits":1, "inserted":17, "deleted":0, "contributors":[{"commits":"1","email":"potherca@gmail.com","name":"Ben Peachey"}]},
]
```

Remote repositories are also supported:

```sh
git_churn https://github.com/potherca-bash/git-churn.git
```

The repository will be cloned to a temporary directory and removed after the script has run.

## Development

This repository uses:

<!-- - [BATS](https://github.com/bats-core/bats-core/) for unit-testing -->
- [`inline-source`](https://bpkg.pother.ca/inline-source/dist/inline_source) to create a single distribution file
- [`shellcheck`](https://www.shellcheck.net/) for BASH quality control
- [`shfmt`](https://github.com/mvdan/sh) to ensure consistent code formatting

This repository is set up like this:

```
    .
    ├── deps/       <-- Third-party dependencies
    ├── dist/       <-- Bundled distrubtion script
    ├── src/        <-- Source files
    ├── bpkg.json   <-- Package declaration
    └── README.md   <-- You are here
```

Dependencies needed by this project are managed through [`bpkg`][bpkg].

To install them (in the `deps/` folder) run:

```sh
bpkg getdeps
```

After that, edits can be made to files in the `src/` directory.

Finally, to create a single file containing all the source logic (this time
using a docker image for `shfmt`), run:

```sh
deps/inline_source/dist/inline_source git_churn.sh \
  | docker run -i --rm --volume="$PWD:/mnt" -w /mnt mvdan/shfmt -i 4 -ci -s \
  > dist/git_churn
```

This will create a distribution file in the `dist/` directory.

[bpkg]: https://github.com/bpkg/bpkg

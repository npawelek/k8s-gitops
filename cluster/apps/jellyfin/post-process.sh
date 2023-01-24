#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

PWD="$(pwd)"

die () {
  echo >&2 "$@"
  cd "${PWD}"
  exit 1
}

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

__path="${1:-}"

# verify a path was provided
[ -n "$__path" ] || die "path is required"
# verify the path exists
[ -f "$__path" ] || die "path ($__path) is not a file"

__dir="$(dirname "${__path}")"
__file="$(basename "${__path}")"
__showstructure="${__dir#/data/Jellyfin Recordings/complete/}"
__destpath="complete/${__showstructure}"

# Debuging path variables
printf "[post-process.sh] %bDebugging variables...%b\npath: ${__path}\ndir: ${__dir}\nshowpath: ${__showstructure}\ndestpath: ${__destpath}\n" "${GREEN}" "${NC}"

# Create destination show path
printf "[post-process.sh] %bCreate destination show path...%b\n" "${GREEN}" "${NC}"
mkdir -p "${__destpath}"

# Change to the directory containing the recording
cd "${__dir}"

# Move recording to complete directory
printf "[post-process.sh] %bMoving recording to complete directory...%b\n"
mv "${__file}" "${__destpath}/${__file}"

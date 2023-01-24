#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

die () {
  echo >&2 "$@"
  cd "${PWD}"
  exit 1
}

__path="${1:-}"

# verify a path was provided
[ -n "$__path" ] || die "path is required"
# verify the path exists
[ -f "$__path" ] || die "path ($__path) is not a file"

__dir="$(dirname "${__path}")"
__file="$(basename "${__path}")"
__dvr_dir="/data/Jellyfin Recordings"
__show_structure="${__dir#${__dvr_dir}/incomplete/}"
__dest_path="complete/${__show_structure}"

# Debuging path variables
printf "[post-process.sh] Debugging variables...\n"
printf "path: ${__path}\n"
printf "dir: ${__dir}\n"
printf "dvr_dir: ${__dvr_dir}\n"
printf "show_structure: ${__show_structure}\n"
printf "dest_path: ${__dest_path}\n"

# Create destination show path
printf "\n[post-process.sh] Create destination show path...\n"
mkdir -v -p "${__dvr_dir}/${__dest_path}"

# Move recording to complete directory
printf "\n[post-process.sh] Moving recording to complete directory...\n"
mv -v "${__path}" "${__dvr_dir}/${__dest_path}/${__file}"

# Cleanup miscellaneous metadata files in dvr directory
printf "\n[post-process.sh] Deleting miscellaneous metadata files...\n"
find "${__dvr_dir}" -name '._*' -exec rm -vf {} \;
find "${__dvr_dir}" -name '*-thumb.bin' -exec rm -vf {} \;
find "${__dvr_dir}" -name '*.nfo' -exec rm -vf {} \;

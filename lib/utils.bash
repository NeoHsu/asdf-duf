#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/muesli/duf"
TOOL_NAME="duf"
TOOL_TEST="duf -version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if duf is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"
  platform=$(get_platform)
  arch=$(get_arch)

  download_file=$(curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/muesli/duf/releases/tags/v${version}" | grep "name" | grep "duf_${version}" | awk '{print $2}' | grep -i "$platform" | grep -i "$arch" | sed -e 's/\"//g' | sed -e 's/,//g')
  url="https://github.com/muesli/duf/releases/download/v${version}/$download_file"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    platform=$(get_platform)
    ext=""
    if [ "$platform" == "windows" ]; then
      ext=".exe"
    fi

    mkdir -p "$install_path/bin"
    cp "$ASDF_DOWNLOAD_PATH/$TOOL_NAME$ext" "$install_path/bin/$TOOL_NAME$ext"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

get_arch() {
  local arch="$(uname -m)"
  echo -n $arch
}

get_platform() {
  local platform="$(uname | tr '[:upper:]' '[:lower:]')"
  echo -n $platform
}

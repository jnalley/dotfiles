#!/usr/bin/env bash

readonly install_path="${HOME}/.aws/aws-cli-bin-$(date +%G%m%d%H%M%S)"
readonly pkgfile="$(mktemp -t tmpfile.XXXXX.bin)"
readonly tmpdir="$(mktemp -t -d tmpdir.XXXXX)"

declare -a tmpfiles=("${pkgfile}" "${tmpdir}")

cleanup() { rm -rf "${tmpfiles[@]}"; }

trap cleanup EXIT

die() { echo "$*" && exit 1; }

inpath() { command -v "${1}" >/dev/null || die "Missing ${1}!"; }

install_from_pkg() {
  mkdir -p "${install_path}" ||
    die "Failed to create ${install_path}"
  inpath pkgutil
  pkgutil --expand "${pkgfile}" "${tmpdir}/t" ||
    die "Failed to expand package!"
  [[ -s "${tmpdir}/t/aws-cli.pkg/Payload" ]] ||
    die "Failed to find Payload!"
  tar -C "${install_path}" -xz --strip-components=2 \
    -f "${tmpdir}/t/aws-cli.pkg/Payload"
}

install_from_zip() {
  inpath unzip
  unzip -q -d "${tmpdir}" "${pkgfile}"
  mkdir -p "${install_path%%/aws-cli-bin*}" ||
    die "Failed to create: ${install_path%%/aws-cli-bin*}"
  mv "${tmpdir}/aws/dist" "${install_path}"
}

install_aws_cli() {
  local url="https://awscli.amazonaws.com"
  local filename

  case "$(uname -s)" in
    Darwin)
      filename=AWSCLIV2.pkg
      ;;
    Linux)
      filename=awscli-exe-linux-x86_64.zip
      ;;
    *)
      die "Unsupported OS!"
      ;;
  esac

  curl -sSL "${url}/${filename}" -o "${pkgfile}" ||
    die "Failed to download: ${url}/${filename}"

  case "${filename}" in
    *.zip)
      install_from_zip
      ;;
    *.pkg)
      install_from_pkg
      ;;
    *)
      die "Unsupported file type!"
      ;;
  esac

  echo "Make sure to add ${install_path} to your PATH" \
    "or create symlinks for ${install_path}/aws and ${install_path}/aws_completer"
}

install_aws_cli || die "Failed to install AWS CLI!"

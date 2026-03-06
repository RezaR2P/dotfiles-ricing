#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="${CONFIG_DIR}/restore-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0

usage() {
  cat <<EOF
Usage: ./restore.sh [--dry-run]

Restore semua config ricing dari repo ini ke ~/.config dengan symlink.

Options:
  --dry-run   Tampilkan aksi tanpa mengubah file
  -h, --help  Tampilkan bantuan
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Argumen tidak dikenal: $arg"
      usage
      exit 1
      ;;
  esac
done

log() {
  printf '%s\n' "$*"
}

run_cmd() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "DRY-RUN: $*"
  else
    eval "$*"
  fi
}

backup_and_link() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -e "$source_path" ]]; then
    log "SKIP source tidak ada: $source_path"
    return
  fi

  local target_dir
  target_dir="$(dirname "$target_path")"
  run_cmd "mkdir -p \"$target_dir\""

  if [[ -L "$target_path" ]]; then
    local current_target
    current_target="$(readlink "$target_path")"
    if [[ "$current_target" == "$source_path" ]]; then
      log "OK sudah link: $target_path -> $source_path"
      return
    fi
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    local rel_path
    rel_path="${target_path#$HOME/}"
    local backup_target="$BACKUP_DIR/$rel_path"
    local backup_target_dir
    backup_target_dir="$(dirname "$backup_target")"
    run_cmd "mkdir -p \"$backup_target_dir\""
    run_cmd "mv \"$target_path\" \"$backup_target\""
    log "BACKUP $target_path -> $backup_target"
  fi

  run_cmd "ln -sfn \"$source_path\" \"$target_path\""
  log "LINK $target_path -> $source_path"
}

CONFIG_DIRS=(
  hypr
  kitty
  swaync
  waybar
  rofi
  wlogout
  gtk-3.0
  gtk-4.0
  nwg-look
  xsettingsd
  htop
)

CONFIG_FILES=(
  dolphinrc
  mimeapps.list
  user-dirs.dirs
  user-dirs.locale
)

if [[ "$DRY_RUN" -eq 0 ]]; then
  mkdir -p "$BACKUP_DIR"
  log "Backup directory: $BACKUP_DIR"
else
  log "Dry run mode aktif (tanpa perubahan file)"
fi

for dir_name in "${CONFIG_DIRS[@]}"; do
  backup_and_link "$DOTFILES_DIR/$dir_name" "$CONFIG_DIR/$dir_name"
done

for file_name in "${CONFIG_FILES[@]}"; do
  backup_and_link "$DOTFILES_DIR/$file_name" "$CONFIG_DIR/$file_name"
done

if [[ "$DRY_RUN" -eq 0 ]]; then
  log "Selesai. Backup tersimpan di: $BACKUP_DIR"
else
  log "Dry run selesai. Tidak ada file yang diubah."
fi

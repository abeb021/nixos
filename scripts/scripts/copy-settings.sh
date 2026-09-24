#!/usr/bin/env bash
# Copy selected settings from the Arch install into the NixOS home.
# Does not dump the whole old home (same idea as Tanjun: pin what matters).
#
# Mounts arch (and optional home partition) when needed, then copies dotfiles.
#
# Live NixOS home on root (typical after migration):
#   sudo bash /home/abeb-nix/nixos/scripts/scripts/copy-settings.sh
#
# Arch home lives on p5 (label home), not under the arch root /home:
#   script mounts both partitions automatically when run as root
#
# Kitty / Hypr only (no full tree):
#   sudo ONLY=kitty,hypr bash /home/abeb-nix/nixos/scripts/scripts/copy-settings.sh
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "run as root: sudo bash copy-settings.sh" >&2
  exit 1
fi

ARCH_ROOT="${ARCH_ROOT:-/mnt/arch-root}"
HOME_MNT="${HOME_MNT:-/mnt/home}"

mount_ro() {
  local dev="$1" mp="$2"
  install -d "$mp"
  if mountpoint -q "$mp" 2>/dev/null; then
    return 0
  fi
  if [[ ! -b "$dev" ]]; then
    echo "missing block device: $dev" >&2
    return 1
  fi
  echo "mount -o ro $dev -> $mp"
  mount -o ro "$dev" "$mp"
}

if [[ -b /dev/disk/by-label/arch ]]; then
  mount_ro /dev/disk/by-label/arch "$ARCH_ROOT" || true
fi
if [[ -b /dev/disk/by-label/home ]]; then
  mount_ro /dev/disk/by-label/home "$HOME_MNT" || true
fi

find_arch_home() {
  local candidate
  for candidate in \
    "${ARCH_HOME:-}" \
    /home/abeb-arch \
    "$HOME_MNT/abeb-arch" \
    "$HOME_MNT/abeb-nix" \
    "$ARCH_ROOT/home/abeb-arch"
  do
    [[ -n "$candidate" && -d "$candidate/.config" ]] || continue
    echo "$candidate"
    return 0
  done
  if mountpoint -q "$HOME_MNT" 2>/dev/null; then
    for candidate in "$HOME_MNT"/*; do
      [[ -d "$candidate/.config/kitty" || -d "$candidate/.config/hypr" ]] || continue
      echo "$candidate"
      return 0
    done
  fi
  return 1
}

SRC="${ARCH_SRC:-}"
if [[ -z "$SRC" ]]; then
  if ! SRC="$(find_arch_home)"; then
    echo "Arch home not found." >&2
    echo "  Arch used a separate /home on label=home (see $ARCH_ROOT/etc/fstab)." >&2
    echo "  Try: sudo mount -o ro /dev/disk/by-label/home $HOME_MNT" >&2
    echo "  Or:  sudo ARCH_SRC=$HOME_MNT/YOUR_USER bash copy-settings.sh" >&2
    exit 1
  fi
  echo "using Arch home: $SRC"
fi

if [[ -z "${DEST:-}" ]]; then
  if [[ -d /home/abeb-nix ]]; then
    DEST=/home/abeb-nix
  elif [[ -d "$HOME_MNT/abeb-nix" ]]; then
    DEST="$HOME_MNT/abeb-nix"
  else
    DEST=/mnt/home/abeb-nix
  fi
fi

ONLY="${ONLY:-}"

install -d -o 1000 -g 100 -m 700 "$DEST"

copy_dir() {
  local rel="$1"
  if [[ ! -e "$SRC/$rel" ]]; then
    echo "skip $rel"
    return 0
  fi
  install -d -o 1000 -g 100 "$(dirname "$DEST/$rel")"
  cp -a "$SRC/$rel" "$(dirname "$DEST/$rel")/"
}

copy_dirs=(
  .ssh .gnupg .oh-my-zsh
  .config/tanjun .config/kitty .config/niri .config/nvim
  .config/btop .config/htop .config/mpv .config/lazygit
  .config/gh
  .config/AmneziaVPN.ORG .config/wireshark
)
# GTK / XDG user dirs: Home Manager (modules/home/gtk.nix). Do not copy from Arch.

# Live Hypr config comes from Tanjun (~/.local/share/tanjun); copy wallpapers/assets only.
copy_hypr_assets() {
  local rel
  for rel in assets wallpapers; do
    if [[ -d "$SRC/.config/hypr/$rel" ]]; then
      install -d -o 1000 -g 100 "$DEST/.config/hypr"
      cp -a "$SRC/.config/hypr/$rel" "$DEST/.config/hypr/"
    fi
  done
}
# .zshrc: Home Manager (modules/home/zsh). Only the p10k theme file is copied.
copy_files=(
  .p10k.zsh .gitconfig .git-credentials .npmrc
  .config/mimeapps.list
  .kube/config
)

if [[ -n "$ONLY" ]]; then
  IFS=',' read -r -a only_parts <<<"$ONLY"
  copy_dirs=()
  copy_files=()
  for part in "${only_parts[@]}"; do
    case "$part" in
      kitty) copy_dirs+=(".config/kitty") ;;
      hypr) ;;
      tanjun) copy_dirs+=(".config/tanjun") ;;
      zsh) copy_files+=(".p10k.zsh") ;;
      *) echo "unknown ONLY=$part (kitty,hypr,tanjun,zsh)" >&2; exit 1 ;;
    esac
  done
fi

for d in "${copy_dirs[@]}"; do
  copy_dir "$d"
done

want_hypr_assets=0
if [[ -z "$ONLY" ]]; then
  want_hypr_assets=1
else
  IFS=',' read -r -a _only_parts <<<"$ONLY"
  for part in "${_only_parts[@]}"; do
    [[ "$part" == hypr ]] && want_hypr_assets=1
  done
fi
if [[ "$want_hypr_assets" -eq 1 ]]; then
  copy_hypr_assets
fi

for f in "${copy_files[@]}"; do
  if [[ ! -e "$SRC/$f" ]]; then
    echo "skip $f"
    continue
  fi
  install -d -o 1000 -g 100 "$(dirname "$DEST/$f")"
  cp -a "$SRC/$f" "$DEST/$f"
done

if [[ -n "$ONLY" ]]; then
  chown -R --no-dereference 1000:100 "$DEST"
  echo "copied ONLY=$ONLY into $DEST from $SRC"
  exit 0
fi

# VS Code / Cursor: managed by Home Manager (modules/home/). Refresh JSON there from Arch if needed.

install -d -o 1000 -g 100 "$DEST/.local/share" "$DEST/.config"
# sudo resets HOME to /root; default to the live user checkout.
tanjun_src="${TANJUN_SRC:-/home/abeb-nix/Programming/Tanjun-shell}"
if [[ ! -d "$tanjun_src/shell" && -d "$DEST/Programming/Tanjun-shell/shell" ]]; then
  tanjun_src="$DEST/Programming/Tanjun-shell"
fi
if [[ -d "$tanjun_src/shell" ]]; then
  ln -sfn "$tanjun_src" "$DEST/.local/share/tanjun"
  ln -sfn "$DEST/.local/share/tanjun/shell" "$DEST/.config/quickshell"
else
  echo "skip tanjun symlinks (no Tanjun checkout at TANJUN_SRC or ~/Programming/Tanjun-shell)" >&2
fi
bg="$DEST/.config/hypr/assets/wallpapers/emerald.jpg"
if [[ -f "$bg" ]]; then
  ln -sfn "$bg" "$DEST/.config/background"
fi
chown -R --no-dereference 1000:100 "$DEST"
chmod 700 "$DEST"

echo "copied into $DEST from $SRC"
du -xh -d 1 "$DEST" | sort -h

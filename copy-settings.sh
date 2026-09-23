#!/usr/bin/env bash
# Copy selected settings into the empty NixOS home. Does not dump the old home.
# Run: sudo bash copy-settings.sh
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "run as root: sudo bash copy-settings.sh" >&2
  exit 1
fi

SRC=/home/abeb-arch
DEST=/mnt/home/abeb-nix

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

for d in \
  .ssh .gnupg .oh-my-zsh \
  .config/hypr .config/tanjun .config/kitty .config/niri .config/nvim \
  .config/btop .config/htop .config/mpv .config/lazygit \
  .config/gtk-3.0 .config/gtk-4.0 .config/gh \
  .config/AmneziaVPN.ORG .config/wireshark \
  Programming/Tanjun-shell nixos
do
  copy_dir "$d"
done

for f in \
  .zshrc .p10k.zsh .gitconfig .git-credentials .npmrc \
  .config/mimeapps.list .config/user-dirs.dirs .config/user-dirs.locale \
  .kube/config \
  .config/Code/User/settings.json .config/Code/User/keybindings.json \
  .config/Cursor/User/settings.json .config/Cursor/User/keybindings.json
do
  if [[ ! -e "$SRC/$f" ]]; then
    echo "skip $f"
    continue
  fi
  install -d -o 1000 -g 100 "$(dirname "$DEST/$f")"
  cp -a "$SRC/$f" "$DEST/$f"
done

for ed in Code Cursor; do
  if [[ -d "$SRC/.config/$ed/User/snippets" ]]; then
    install -d -o 1000 -g 100 "$DEST/.config/$ed/User"
    cp -a "$SRC/.config/$ed/User/snippets" "$DEST/.config/$ed/User/"
  fi
done

install -d -o 1000 -g 100 "$DEST/.local/share" "$DEST/.config"
ln -sfn /home/abeb-nix/Programming/Tanjun-shell "$DEST/.local/share/tanjun"
ln -sfn /home/abeb-nix/.local/share/tanjun/shell "$DEST/.config/quickshell"
ln -sfn /home/abeb-nix/.config/hypr/assets/wallpapers/emerald.jpg "$DEST/.config/background"
chown -R --no-dereference 1000:100 "$DEST"
chmod 700 "$DEST"

echo "copied into $DEST"
du -xh -d 1 "$DEST" | sort -h

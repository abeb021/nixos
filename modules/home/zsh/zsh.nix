# Prompt theme lives in ~/.p10k.zsh (copied from Arch). This file owns .zshrc.
{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      (lib.mkOrder 550 ''
        zstyle ':completion:*' matcher-list \
            'm:{[:lower:]}={[:upper:]}' \
            '+r:|[._-]=* r:|=*' \
            '+l:|=*'
        zstyle ':completion:*' menu no
        zstyle ':completion:*' group-name ''''
        zstyle ':completion:*' format '%B--- %d ---%b'
        zstyle ':completion:*' verbose true
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      '')

      ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        if (( $+commands[fzf] )); then
          [[ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ]] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        fi
        bindkey '^I' expand-or-complete
        bindkey '^[[Z' reverse-menu-complete

        export PATH="$PATH:$(go env GOPATH 2>/dev/null)/bin"
        export PATH="$HOME/.npm-global/bin:$PATH"
      ''
    ];
  };
}

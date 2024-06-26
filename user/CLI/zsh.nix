{ config, ... }:
{
  programs.zsh = {
    enable = true;
    # autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.size = 1000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    initExtra = builtins.readFile ./../../config_files/dynamic/zsh;
  };
}

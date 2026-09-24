# Every scripts/scripts/*.sh becomes a command on PATH.
# ascii.sh is installed as `ascii`. Discovery uses the filesystem (readDir).
{ pkgs, ... }:
let
  scriptDir = ./scripts;
  scriptEntries = builtins.readDir scriptDir;

  regularFiles = builtins.filter (name: scriptEntries.${name} == "regular") (
    builtins.attrNames scriptEntries
  );

  shellScripts = builtins.filter (name: builtins.match ".*\\.sh$" name != null) regularFiles;

  mkScript = name: {
    name = builtins.replaceStrings [ ".sh" ] [ "" ] name;
    value = pkgs.writeScriptBin (builtins.replaceStrings [ ".sh" ] [ "" ] name) (
      builtins.readFile (scriptDir + "/${name}")
    );
  };

  scripts = builtins.attrValues (builtins.listToAttrs (map mkScript shellScripts));
in
{
  home.packages = scripts;
}

# https://github.com/abeb021/simplicity-sddm-theme
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "simplicity-sddm-theme";
  version = "25.09";

  src = fetchFromGitHub {
    owner = "abeb021";
    repo = "simplicity-sddm-theme";
    rev = "80a02dd315eb504dc416806ef2e78005f1940399";
    hash = "sha256-o7hlvIm72j5O9TGrQIYBmmy0XXTtcNIdwgqh/H7+OVw=";
  };

  installPhase = ''
    runHook preInstall
    dst="$out/share/sddm/themes/simplicity"
    mkdir -p "$dst"
    cp Main.qml metadata.desktop theme.conf image.png "$dst/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimal GRUB-style SDDM theme (abeb021)";
    homepage = "https://github.com/abeb021/simplicity-sddm-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}

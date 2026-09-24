{ ... }:
{
  # PipeWire needs rtkit (modules/core/security.nix) for low-latency audio.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}

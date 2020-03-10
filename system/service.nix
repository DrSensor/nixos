{ config, pkgs, ... }:

{
  programs.gnupg.agent.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Libvirtd
  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = [ "ash" ];

  # Configuration to facilitate bluetooth headphones.
  hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  # Enable fwupd service
  services.fwupd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}

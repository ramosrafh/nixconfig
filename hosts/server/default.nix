{ lib, ... }: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ../../modules/nixos/base
    ../../modules/nixos/profiles/server.nix
    ../../modules/nixos/security/secure-boot.nix
    ../../modules/nixos/services/k3s.nix
    ../../modules/nixos/services/netbird.nix
    ../../modules/nixos/services/ssh.nix
  ];

  networking.hostName = "server";

  # This firmware exposes TPM2 but produces an event log incompatible with
  # systemd-pcrlock. Secure Boot remains enabled; TPM unlock uses PCR 7.
  boot.lanzaboote.measuredBoot.enable = lib.mkForce false;

  system.stateVersion = "26.05";
}

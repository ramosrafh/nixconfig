{ lib, primaryUser, ... }: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./secrets.nix
    ./storage.nix
    ../../modules/nixos/base
    ../../modules/nixos/profiles/server.nix
    ../../modules/nixos/security/secure-boot.nix
    ../../modules/nixos/services/adguardhome.nix
    ../../modules/nixos/services/caddy.nix
    ../../modules/nixos/services/docker.nix
    ../../modules/nixos/services/glance.nix
    ../../modules/nixos/services/k3s.nix
    ../../modules/nixos/services/netbird.nix
    ../../modules/nixos/services/ssh.nix
  ];

  networking.hostName = "server";

  # Wifi via nmtui: NetworkManager replaces dhcpcd as the way to configure interfaces.
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkForce false;
  users.users.${primaryUser}.extraGroups = [ "networkmanager" ];

  # This firmware exposes TPM2 but produces an event log incompatible with
  # systemd-pcrlock. Secure Boot remains enabled; TPM unlock uses PCR 7.
  boot.lanzaboote.measuredBoot.enable = lib.mkForce false;

  system.stateVersion = "26.05";
}

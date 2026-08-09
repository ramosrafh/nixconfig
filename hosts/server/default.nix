{ ... }: {
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
  system.stateVersion = "26.05";
}

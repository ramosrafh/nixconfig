{ lib, pkgs, ... }: {
  environment.systemPackages = [ pkgs.sbctl ];

  boot = {
    initrd.systemd.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 5;
      allowUnsigned = false;

      measuredBoot = {
        enable = true;
        pcrs = [ 0 4 7 ];
      };
    };
  };
}

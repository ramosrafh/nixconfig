{ lib, primaryUser, ... }: {
  disko.devices.disk.main = {
    type = "disk";

    # disko-install overrides this with `--disk main <device>`.
    # Keeping a non-existent default makes an accidental destructive run fail.
    device = lib.mkDefault "/dev/disk/by-id/SET-WITH-DISKO-INSTALL";

    content = {
      type = "gpt";
      partitions = {
        EFI = {
          label = "EFI";
          size = "4G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        cryptroot = {
          label = "cryptroot";
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            askPassword = true;
            enrollRecovery = true;
            settings = {
              allowDiscards = true;
              crypttabExtraOpts = [ "tpm2-device=auto" ];
            };

            content = {
              type = "btrfs";
              extraArgs = [ "-f" "-L" "nixos" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@cache" = {
                  mountpoint = "/home/${primaryUser}/.cache";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@docker" = {
                  mountpoint = "/docker";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@home-snapshots" = {
                  mountpoint = "/home/.snapshots";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };

  swapDevices = [ ];
}

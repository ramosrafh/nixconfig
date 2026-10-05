{ lib, ... }: {
  disko.devices.disk.main = {
    type = "disk";

    # The installer overrides this with --disk main <device>.
    # The invalid default prevents accidental formatting without that argument.
    device = lib.mkDefault "/dev/disk/by-id/SELECT-DISK-IN-INSTALLER";

    content = {
      type = "gpt";
      partitions = {
        EFI = {
          label = "EFI";
          size = "2G";
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
              extraArgs = [
                "-f"
                "-L"
                "nixos-server"
              ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@state" = {
                  mountpoint = "/var/lib";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@k3s" = {
                  mountpoint = "/var/lib/rancher/k3s";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@srv" = {
                  mountpoint = "/srv";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
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

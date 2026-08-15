{ lib, ... }: {
  # This is an optional external disk. Keep it out of disko.nix: reinstalling
  # the system disk must never repartition or format homelab data.
  environment.etc."crypttab".text = lib.mkAfter ''
    homelab-data /dev/disk/by-partlabel/homelab-data-crypt none tpm2-device=auto,nofail,x-systemd.device-timeout=5s
  '';

  fileSystems."/srv/homelab" = {
    device = "/dev/mapper/homelab-data";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd:3"
      "noatime"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/homelab 0755 root root -"
  ];
}

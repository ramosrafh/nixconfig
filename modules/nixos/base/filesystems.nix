{ pkgs, ... }: {
  boot.supportedFilesystems = [ "ntfs" ];

  environment.systemPackages = [ pkgs.ntfs3g ];
}

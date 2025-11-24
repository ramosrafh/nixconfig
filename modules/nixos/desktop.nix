{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.udisks2.enable = true;

  # Enable polkit for disk operations
  security.polkit.enable = true;

  # Allow wheel group users to perform udisks2 operations without password
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var YES = polkit.Result.YES;
      var permission = {
        "org.freedesktop.udisks2.filesystem-mount": YES,
        "org.freedesktop.udisks2.filesystem-mount-system": YES,
        "org.freedesktop.udisks2.filesystem-unmount": YES,
        "org.freedesktop.udisks2.encrypted-unlock": YES,
        "org.freedesktop.udisks2.encrypted-lock": YES,
        "org.freedesktop.udisks2.eject-media": YES,
        "org.freedesktop.udisks2.power-off-drive": YES,
        "org.freedesktop.udisks2.filesystem-fstab": YES,
        "org.freedesktop.udisks2.modify-device": YES,
        "org.freedesktop.udisks2.modify-device-system": YES,
        "org.freedesktop.udisks2.loop-setup": YES,
        "org.freedesktop.udisks2.loop-delete": YES,
        "org.freedesktop.udisks2.loop-modify": YES,
        "org.freedesktop.udisks2.ata-smart-update": YES,
        "org.freedesktop.udisks2.ata-smart-selftest": YES,
        "org.freedesktop.udisks2.drive-ata-smart-selftest": YES
      };
      if (subject.isInGroup("wheel")) {
        return permission[action.id];
      }
    });
  '';

  # Enable SOF firmware for audio
  hardware.firmware = [ pkgs.sof-firmware ];

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    wl-clipboard
    git
    helix
    btop
    ripgrep
    fd
    eza
    pavucontrol
    pulseaudio
    ntfs3g
    gnome-disk-utility
  ];
}

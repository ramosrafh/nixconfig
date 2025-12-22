{ pkgs, ... }: {
  # Minimal audio setup with PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  # GNOME services for GTK4/libadwaita apps like Nautilus
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.gnome.at-spi2-core.enable = true;

  # System-wide environment variables for GTK4 theme support
  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    GSETTINGS_BACKEND = "dconf";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    # Disable graphical SSH password prompts - prevent gnome-keyring from handling SSH
    SSH_ASKPASS = "";
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
  };

  services.udisks2.enable = true;

  # Enable ratbagd for Piper (gaming mouse configuration)
  services.ratbagd.enable = true;

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

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      niri = {
        default = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
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
    pciutils  # for lspci
    usbutils  # for lsusb
    ntfs3g
    gnome-disk-utility
    # GTK4 and libadwaita support
    gtk4
    libadwaita
    gsettings-desktop-schemas
    adwaita-icon-theme
    gnome-keyring
    nautilus
  ];
}

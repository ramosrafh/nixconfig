{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.at-spi2-core.enable = true;

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    GSETTINGS_BACKEND = "dconf";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    # Force terminal-based SSH password prompts instead of gcr/askpass.
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
    GCR_SSH_ASKPASS = "";
  };

  systemd.user.services.gnome-keyring-ssh.enable = false;

  services.udisks2.enable = true;
  services.ratbagd.enable = true;

  security.polkit.enable = true;
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
      common.default = [ "gtk" ];
      niri = {
        default = [ "gtk" ];
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
    pciutils
    usbutils
    ntfs3g
    gnome-disk-utility
    gtk4
    libadwaita
    gsettings-desktop-schemas
    adwaita-icon-theme
    gnome-keyring
    gnome-online-accounts
    gnome-control-center
    nautilus
    irpf
  ];
}

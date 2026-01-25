{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      gamescope
      vulkan-loader
      vulkan-tools
      mesa
      libva
      wayland
      libxkbcommon
      # X11 libs needed for games
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      xorg.libxcb
    ];
    extraCompatPackages = with pkgs; [
      vulkan-loader
    ];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    gamescope
  ];

  # Wrapper script to launch Steam in gamescope (native Wayland)
  environment.shellAliases = {
    steam-wayland = "gamescope -W 1920 -H 1200 -f --grab --force-grab-cursor -- steam -tenfoot -pipewire";
  };
}

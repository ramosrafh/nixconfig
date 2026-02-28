{ pkgs, ... }: {
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        # Better device discovery
        DiscoverableTimeout = 0;
        # Fast connection
        FastConnectable = true;
      };
    };
  };

  # Bluetooth manager GUI
  services.blueman.enable = true;

  # Ensure PipeWire handles Bluetooth audio
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}

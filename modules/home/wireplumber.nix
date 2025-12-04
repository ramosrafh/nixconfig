{ config, pkgs, lib, hostConfig ? "desk", ... }:

{
  # WirePlumber configuration for HDMI audio routing
  # Prioritizes HDMI outputs from AMD GPU for the Acer monitor (which has built-in speakers)
  # Handles both DP-1 (hdmi-stereo) and DP-2 (hdmi-stereo-extra1) configurations

  xdg.configFile = lib.mkIf (hostConfig == "desk") {
    # Configure ALSA monitor rules to prioritize all HDMI outputs
    "wireplumber/wireplumber.conf.d/51-hdmi-audio.conf".text = ''
      # HDMI/DisplayPort audio configuration for AMD GPU
      # Prioritizes all HDMI outputs so the Acer monitor is used regardless of which DP it's on
      # - hdmi-stereo = HDMI 1 (when Acer is on DP-1)
      # - hdmi-stereo-extra1 = HDMI 2 (when Acer is on DP-2)

      monitor.alsa.rules = [
        # High priority for all AMD GPU HDMI outputs
        {
          matches = [
            {
              node.name = "~alsa_output.pci-0000_2d_00.1.hdmi-stereo*"
            }
          ]
          actions = {
            update-props = {
              priority.driver = 3000
              priority.session = 3000
            }
          }
        }
      ]
    '';

    # Configure stream behavior
    "wireplumber/wireplumber.conf.d/52-stream-config.conf".text = ''
      # Stream configuration
      # Allow streams to move when default device changes

      wireplumber.settings = {
        # Allow moving streams to new default when it changes
        linking.allow-moving-streams = true
      }
    '';
  };
}

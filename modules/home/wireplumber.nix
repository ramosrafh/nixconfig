{ config, pkgs, lib, hostConfig ? "desk", ... }:

{
  # WirePlumber configuration for dynamic HDMI audio routing
  # This ensures audio follows the active HDMI/DisplayPort output
  # regardless of which physical port is being used

  xdg.configFile = lib.mkIf (hostConfig == "desk") {
    # Configure ALSA monitor rules for HDMI audio priority
    "wireplumber/wireplumber.conf.d/50-hdmi-audio.conf".text = ''
      # HDMI/DisplayPort audio configuration for AMD GPU
      # Increases priority of HDMI audio outputs so they are preferred

      monitor.alsa.rules = [
        # Match all HDMI audio sinks from AMD GPU and increase priority
        {
          matches = [
            {
              node.name = "~alsa_output.pci-*hdmi*"
            }
          ]
          actions = {
            update-props = {
              priority.driver = 2000
              priority.session = 2000
            }
          }
        }
      ]
    '';

    # Configure stream restore behavior
    "wireplumber/wireplumber.conf.d/51-stream-restore.conf".text = ''
      # Stream restore configuration
      # Allow streams to move when default device changes

      wireplumber.settings = {
        # Allow moving streams to new default when it changes
        linking.allow-moving-streams = true
      }
    '';

    # Use device description for better matching instead of specific node names
    "wireplumber/wireplumber.conf.d/52-alsa-config.conf".text = ''
      # ALSA device configuration
      # Prefer stereo profile for HDMI outputs

      monitor.alsa.rules = [
        # AMD GPU audio device - use ACP for automatic profile selection
        {
          matches = [
            {
              device.name = "~alsa_card.pci-*"
              device.nick = "~*HD-Audio*"
            }
          ]
          actions = {
            update-props = {
              api.alsa.use-acp = true
            }
          }
        }
      ]
    '';
  };
}

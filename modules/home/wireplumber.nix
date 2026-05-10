{ lib, hostConfig ? "desk", ... }:

{
  xdg.configFile = lib.mkIf (hostConfig == "desk") {
    "wireplumber/wireplumber.conf.d/51-hdmi-audio.conf".text = ''
      wireplumber.settings = {
        device.restore-profile = false
        linking.allow-moving-streams = true
        linking.follow-default-target = true
      }

      device.profile.priority.rules = [
        {
          matches = [
            {
              device.name = "alsa_card.pci-0000_2d_00.1"
            }
          ]
          actions = {
            update-props = {
              priorities = [
                "output:hdmi-stereo"
                "output:hdmi-stereo-extra1"
              ]
            }
          }
        }
      ]

      monitor.alsa.rules = [
        {
          matches = [
            {
              node.name = "alsa_output.pci-0000_2d_00.1.hdmi-stereo"
            }
          ]
          actions = {
            update-props = {
              priority.driver = 4000
              priority.session = 4000
            }
          }
        }
      ]
    '';
  };
}

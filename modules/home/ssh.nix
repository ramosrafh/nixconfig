{ pkgs, ... }: {
  programs.ssh = {
    enable = true;

    matchBlocks = {
      # Work machines - all use driva key
      "d0" = {
        hostname = "ns5032804.ip-148-113-208.net";
        user = "debian";
        identityFile = "~/.ssh/driva";
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
      };

      "d1" = {
        hostname = "ns5032832.ip-148-113-208.net";
        user = "debian";
        identityFile = "~/.ssh/driva";
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
      };

      "d2" = {
        hostname = "ns5029795.ip-148-113-189.net";
        user = "debian";
        identityFile = "~/.ssh/driva";
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
      };

      "services" = {
        hostname = "ns5033463.ip-148-113-210.net";
        user = "debian";
        identityFile = "~/.ssh/driva";
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
      };

      "homolog" = {
        hostname = "ns531059.ip-149-56-25.net";
        user = "ubuntu";
        identityFile = "~/.ssh/driva";
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
      };

      "ddb" = {
        hostname = "driva-db.driva.io";
        user = "debian";
        identityFile = "~/.ssh/driva";
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
      };
    };
  };
}

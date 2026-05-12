{ ... }:

let
  controlOptions = {
    AddKeysToAgent = "yes";
    ControlMaster = "auto";
    ControlPath = "~/.ssh/control-%r@%h:%p";
    ControlPersist = "10m";
  };

  agentOptions = {
    AddKeysToAgent = "yes";
  };

  drivaHost = hostname: user: {
    inherit hostname user;
    identityFile = "~/.ssh/driva";
    extraOptions = controlOptions;
  };

  githubHost = identityFile: {
    hostname = "github.com";
    user = "git";
    inherit identityFile;
    extraOptions = agentOptions;
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "d0" = drivaHost "ns5032804.ip-148-113-208.net" "debian";
      "d1" = drivaHost "ns5032832.ip-148-113-208.net" "debian";
      "d2" = drivaHost "ns5029795.ip-148-113-189.net" "debian";
      "services" = drivaHost "ns5033463.ip-148-113-210.net" "debian";
      "homolog" = drivaHost "ns531059.ip-149-56-25.net" "ubuntu";
      "ddb" = drivaHost "driva-db.driva.io" "debian";

      "hetz" = {
        hostname = "46.225.24.175";
        user = "ramos";
        identityFile = "~/.ssh/ramos";
        extraOptions = controlOptions;
      };

      "github.com-ramos" = githubHost "~/.ssh/ramos";
      "github.com-driva" = githubHost "~/.ssh/driva";
      "github.com" = githubHost "~/.ssh/ramos";
    };
  };
}

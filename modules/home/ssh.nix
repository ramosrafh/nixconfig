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
    HostName = hostname;
    User = user;
    IdentityFile = "~/.ssh/driva";
  } // controlOptions;

  githubHost = identityFile: {
    HostName = "github.com";
    User = "git";
    IdentityFile = identityFile;
  } // agentOptions;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "d0" = drivaHost "ns5032804.ip-148-113-208.net" "debian";
      "d1" = drivaHost "ns5032832.ip-148-113-208.net" "debian";
      "d2" = drivaHost "ns5029795.ip-148-113-189.net" "debian";
      "services" = drivaHost "ns5033463.ip-148-113-210.net" "debian";
      "homolog" = drivaHost "ns531059.ip-149-56-25.net" "ubuntu";
      "ddb" = drivaHost "driva-db.driva.io" "debian";

      "hetz" = {
        HostName = "46.225.24.175";
        User = "ramos";
        IdentityFile = "~/.ssh/ramos";
      } // controlOptions;

      "github.com-ramos" = githubHost "~/.ssh/ramos";
      "github.com-driva" = githubHost "~/.ssh/driva";
      "github.com" = githubHost "~/.ssh/ramos";
    };
  };
}

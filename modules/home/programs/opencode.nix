{ pkgs, ... }:
{
  home.packages = [ pkgs.opencode ];

  # Keep the credential in the user's environment, outside the Nix store.
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider.openrouter.options.apiKey = "{env:OPENROUTER_API_KEY}";
    provider.driva = {
      npm = "@ai-sdk/openai-compatible";
      options = {
        baseURL = "http://vpn-driva.netbird.driva.io:8317/v1";
        apiKey = "{env:OPENAI_API_KEY}";
      };
      models = {
        "glm/glm-5.3".name = "driva/glm-5.3";
        "kimi/kimi-k3".name = "driva/kimi-k3";
      };
    };
  };
}

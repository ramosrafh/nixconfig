{ pkgs, ... }:
{
  home.packages = [ pkgs.opencode ];

  # Keep the credential in the user's environment, outside the Nix store.
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider.openrouter.options.apiKey = "{env:OPENROUTER_API_KEY}";
  };
}

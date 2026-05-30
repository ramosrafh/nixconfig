{ pkgs, ... }:
let
  brokenPine = import ./broken-pine.nix;
in {
  home.file.".config/fuzzel/fuzzel.ini".text = ''
    [main]
    font=Inter:size=14:weight=medium
    icon-theme=Papirus-Dark
    icons-enabled=yes
    image-size-ratio=0.5
    lines=8
    width=45
    horizontal-pad=20
    vertical-pad=12
    inner-pad=8
    line-height=28
    letter-spacing=0.5
    layer=overlay
    prompt="  "
    placeholder=Buscar...

    [border]
    width=2
    radius=0

    [colors]
    # Broken Pine
    background=${brokenPine.withAlpha brokenPine.background "f2"}
    text=${brokenPine.withAlpha brokenPine.text "ff"}
    prompt=${brokenPine.withAlpha brokenPine.blue "ff"}
    placeholder=${brokenPine.withAlpha brokenPine.placeholder "ff"}
    input=${brokenPine.withAlpha brokenPine.text "ff"}
    match=${brokenPine.withAlpha brokenPine.blue "ff"}
    selection=${brokenPine.withAlpha brokenPine.surfaceActive "ff"}
    selection-text=${brokenPine.withAlpha brokenPine.textAlt "ff"}
    selection-match=${brokenPine.withAlpha brokenPine.orange "ff"}
    counter=${brokenPine.withAlpha brokenPine.mutedAlt "ff"}
    border=${brokenPine.withAlpha brokenPine.borderFocused "80"}
  '';
}

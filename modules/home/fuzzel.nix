{ pkgs, ... }: {
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
    # Catppuccin Mocha
    background=1e1e2ef2
    text=cdd6f4ff
    prompt=cba6f7ff
    placeholder=6c7086ff
    input=cdd6f4ff
    match=cba6f7ff
    selection=313244ff
    selection-text=cdd6f4ff
    selection-match=f5c2e7ff
    counter=6c7086ff
    border=cba6f780
  '';
}

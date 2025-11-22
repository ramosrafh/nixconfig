{ pkgs, ... }: {
  home.file.".config/fuzzel/fuzzel.ini".text = ''
    [main]
    border-radius=0
    font=monospace:size=25
    image-size-ratio=0.9
    lines=5
    line-height=42

    [colors]
    background=1e1e2edd
    text=cdd6f4ff
    prompt=bac2deff
    placeholder=7f849cff
    input=cdd6f4ff
    match=74c7ecff
    selection=585b70ff
    selection-text=cdd6f4ff
    selection-match=74c7ecff
    counter=7f849cff
    bder=919191
  '';
}

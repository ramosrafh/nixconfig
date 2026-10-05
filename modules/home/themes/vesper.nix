let
  colors = rec {
    name = "Vesper";

    background = "#101010";
    surface = "#161616";
    surfaceVariant = "#232323";
    surfaceActive = "#282828";
    border = "#343434";
    borderFocused = "#FFC799";

    text = "#FFFFFF";
    textAlt = "#FFFFFF";
    muted = "#A0A0A0";
    mutedAlt = "#707070";
    disabled = "#505050";
    placeholder = "#505050";

    red = "#FF8080";
    green = "#90B99F";
    yellow = "#FFC799";
    blue = "#90B99F";
    cyan = "#90B99F";
    magenta = "#FFC799";
    purple = "#FFC799";
    orange = "#FFC799";
    keyword = "#A0A0A0";
    property = "#FFFFFF";
    attribute = "#FFC799";
  };
in
colors
// {
  noHash = color: builtins.substring 1 6 color;
  withAlpha = color: alpha: "${builtins.substring 1 6 color}${alpha}";
}

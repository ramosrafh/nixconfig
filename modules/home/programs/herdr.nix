{ ... }:
{
  xdg.configFile."herdr/config.toml".text = ''
    [theme]
    name = "vesper"

    [keys]
    prefix = "ctrl+space"
    focus_pane_left = "prefix+h"
    focus_pane_down = "prefix+j"
    focus_pane_up = "prefix+k"
    focus_pane_right = "prefix+l"
    split_horizontal = "prefix+minus"
    split_vertical = "prefix+|"
    new_tab = "prefix+c"
    close_tab = "prefix+ampersand"
    workspace_picker = "prefix+w"
    goto = "prefix+g"
    copy_mode = "prefix+y"

    [ui]
    agent_panel_sort = "spaces"
  '';
}

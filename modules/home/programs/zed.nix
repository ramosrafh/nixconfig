{ ... }:
let
  syntax = color: {
    inherit color;
    font_style = null;
    font_weight = null;
  };
in
{
  home.file.".config/zed/settings.json" = {
    force = true;
    text = builtins.toJSON {
      theme = "Vesper Theme";
      icon_theme = "Zed (Default)";
      buffer_font_family = "JetBrainsMono Nerd Font";
      ui_font_family = "Inter";
      feature_flags = {
        notebooks = "on";
        "tabular-data-preview" = "on";
      };
    };
  };

  home.file.".config/zed/themes/vesper.json" = {
    force = true;
    text = builtins.toJSON {
      name = "Vesper";
      author = "Etienne Lacoursiere";
      themes = [
        {
          name = "Vesper Theme";
          appearance = "dark";
          style = {
            border = "#423f55ff";
            "border.variant" = "#232323ff";
            "border.focused" = "#435255ff";
            "border.selected" = "#435255ff";
            "border.transparent" = "#00000000";
            "border.disabled" = "#353347ff";
            "elevated_surface.background" = "#161616";
            "surface.background" = "#161616";
            background = "#101010";
            "element.background" = "#161616";
            "element.hover" = "#232323ff";
            "element.active" = "#282828ff";
            "element.selected" = "#282828ff";
            "element.disabled" = "#161616";
            "drop_target.background" = "#70707080";
            "ghost_element.background" = "#00000000";
            "ghost_element.hover" = "#232323ff";
            "ghost_element.active" = "#282828ff";
            "ghost_element.selected" = "#282828ff";
            "ghost_element.disabled" = "#161616";
            text = "#FFFFFF";
            "text.muted" = "#A0A0A0";
            "text.placeholder" = "#2f2b43ff";
            "text.disabled" = "#6e6a86ff";
            "text.accent" = "#FFC799ff";
            icon = "#e0def4ff";
            "icon.muted" = "#707070ff";
            "icon.disabled" = "#2f2b43ff";
            "icon.placeholder" = "#707070ff";
            "icon.accent" = "#FFC799ff";
            "status_bar.background" = "#101010";
            "title_bar.background" = "#101010";
            "toolbar.background" = "#101010";
            "tab_bar.background" = "#101010";
            "tab.inactive_background" = "#101010";
            "tab.active_background" = "#101010";
            "search.match_background" = "#57949f66";
            "panel.background" = "#101010";
            "panel.focused_border" = null;
            "pane.focused_border" = null;
            "scrollbar.thumb.background" = "#e0def44c";
            "scrollbar.thumb.hover_background" = "#232323ff";
            "scrollbar.thumb.border" = "#232323ff";
            "scrollbar.track.background" = "#00000000";
            "scrollbar.track.border" = "#1b1a29ff";
            "editor.foreground" = "#FFFFFF";
            "editor.background" = "#101010";
            "editor.gutter.background" = "#101010";
            "editor.subheader.background" = "#161616";
            "editor.active_line.background" = "#161616";
            "editor.highlighted_line.background" = "#161616";
            "editor.line_number" = "#A0A0A0";
            "editor.active_line_number" = "#e0def4ff";
            "editor.invisible" = "#28253cff";
            "editor.wrap_guide" = "#e0def40d";
            "editor.active_wrap_guide" = "#e0def41a";
            "editor.document_highlight.read_background" = "#FFC7991a";
            "editor.document_highlight.write_background" = "#28253c66";
            "terminal.background" = "#101010";
            "terminal.foreground" = "#e0def4ff";
            "terminal.bright_foreground" = "#e0def4ff";
            "terminal.dim_foreground" = "#101010";
            "terminal.ansi.black" = "#101010";
            "terminal.ansi.bright_black" = "#403d55ff";
            "terminal.ansi.dim_black" = "#e0def4ff";
            "terminal.ansi.red" = "#FF8080ff";
            "terminal.ansi.bright_red" = "#7e3647ff";
            "terminal.ansi.dim_red" = "#fab9c6ff";
            "terminal.ansi.green" = "#99FFE4ff";
            "terminal.ansi.bright_green" = "#31614fff";
            "terminal.ansi.dim_green" = "#b3e1d1ff";
            "terminal.ansi.yellow" = "#f5c177ff";
            "terminal.ansi.bright_yellow" = "#8a643aff";
            "terminal.ansi.dim_yellow" = "#fedfbbff";
            "terminal.ansi.blue" = "#FFC799ff";
            "terminal.ansi.bright_blue" = "#566b70ff";
            "terminal.ansi.dim_blue" = "#cfe7ebff";
            "terminal.ansi.magenta" = "#9d7591ff";
            "terminal.ansi.bright_magenta" = "#4c3b47ff";
            "terminal.ansi.dim_magenta" = "#ceb9c7ff";
            "terminal.ansi.cyan" = "#31738fff";
            "terminal.ansi.bright_cyan" = "#203a46ff";
            "terminal.ansi.dim_cyan" = "#9cb7c6ff";
            "terminal.ansi.white" = "#e0def4ff";
            "terminal.ansi.bright_white" = "#e0def4ff";
            "terminal.ansi.dim_white" = "#514e68ff";
            "link_text.hover" = "#FFC799ff";
            conflict = "#f5c177ff";
            "conflict.background" = "#50331aff";
            "conflict.border" = "#6d4d2bff";
            created = "#99FFE4ff";
            "created.background" = "#182d23ff";
            "created.border" = "#254839ff";
            deleted = "#FF8080ff";
            "deleted.background" = "#431720ff";
            "deleted.border" = "#612834ff";
            error = "#FF8080ff";
            "error.background" = "#431720ff";
            "error.border" = "#612834ff";
            hidden = "#2f2b43ff";
            "hidden.background" = "#292738ff";
            "hidden.border" = "#353347ff";
            hint = "#5e768cff";
            "hint.background" = "#2f3639ff";
            "hint.border" = "#435255ff";
            ignored = "#707070ff";
            "ignored.background" = "#292738ff";
            "ignored.border" = "#423f55ff";
            info = "#FFC799ff";
            "info.background" = "#2f3639ff";
            "info.border" = "#435255ff";
            modified = "#FFAF87";
            "modified.background" = "#50331aff";
            "modified.border" = "#6d4d2bff";
            predictive = "#556b81ff";
            "predictive.background" = "#182d23ff";
            "predictive.border" = "#254839ff";
            renamed = "#FFC799ff";
            "renamed.background" = "#2f3639ff";
            "renamed.border" = "#435255ff";
            success = "#99FFE4ff";
            "success.background" = "#182d23ff";
            "success.border" = "#254839ff";
            unreachable = "#707070ff";
            "unreachable.background" = "#292738ff";
            "unreachable.border" = "#423f55ff";
            warning = "#f5c177ff";
            "warning.background" = "#50331aff";
            "warning.border" = "#6d4d2bff";
            players = [
              {
                cursor = "#FFC799ff";
                background = "#FFC799ff";
                selection = "#FFC7993d";
              }
              {
                cursor = "#9d7591ff";
                background = "#9d7591ff";
                selection = "#9d75913d";
              }
              {
                cursor = "#c4a7e6ff";
                background = "#c4a7e6ff";
                selection = "#c4a7e63d";
              }
              {
                cursor = "#31738fff";
                background = "#31738fff";
                selection = "#31738f3d";
              }
              {
                cursor = "#FF8080ff";
                background = "#FF8080ff";
                selection = "#FF80803d";
              }
              {
                cursor = "#f5c177ff";
                background = "#f5c177ff";
                selection = "#f5c1773d";
              }
              {
                cursor = "#99FFE4ff";
                background = "#99FFE4ff";
                selection = "#99FFE43d";
              }
            ];
            syntax = {
              attribute = syntax "#D7AFD7";
              boolean = syntax "#FFAFAF";
              comment = syntax "#6e6a86ff";
              "comment.doc" = syntax "#76728fff";
              constant = syntax "#FFAF87";
              constructor = syntax "#FFAF87";
              embedded = syntax "#FFFFFF";
              emphasis = syntax "#FF8080";
              "emphasis.strong" = (syntax "#FF8080") // {
                font_weight = 700;
              };
              enum = syntax "#FFAF87";
              function = syntax "#FFAFAF";
              hint = (syntax "#5e768cff") // {
                font_weight = 700;
              };
              keyword = syntax "#5F8787";
              label = syntax "#FF8080";
              link_text = (syntax "#FFC799ff") // {
                font_style = "italic";
              };
              link_uri = syntax "#FFC799ff";
              number = syntax "#FFAF87";
              operator = syntax "#A0A0A0";
              predictive = (syntax "#556b81ff") // {
                font_style = "italic";
              };
              preproc = syntax "#5F8787";
              primary = syntax "#FFFFFF";
              property = (syntax "#AFD7D7") // {
                font_style = "italic";
              };
              punctuation = syntax "#A0A0A0";
              "punctuation.bracket" = syntax "#A0A0A0";
              "punctuation.delimiter" = syntax "#A0A0A0";
              "punctuation.list_marker" = syntax "#FF8080";
              "punctuation.special" = syntax "#FFFFFF";
              string = syntax "#FFAF87";
              "string.escape" = syntax "#5F8787";
              "string.regex" = syntax "#FF8080";
              "string.special" = syntax "#FFAF87";
              "string.special.symbol" = syntax "#FFFFFF";
              tag = syntax "#AFD7D7";
              "text.literal" = syntax "#FFAF87";
              title = (syntax "#FFFFFF") // {
                font_weight = 700;
              };
              type = syntax "#AFD7D7";
              variable = syntax "#FFFFFF";
              variant = syntax "#FFAF87";
            };
          };
        }
      ];
    };
  };
}

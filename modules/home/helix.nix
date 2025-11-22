{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "mocha";
      
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };

      keys.normal = {
        C-h = ":sh zellij ac move-focus-or-tab left";
        C-j = ":sh zellij ac move-focus-or-tab down";
        C-k = ":sh zellij ac move-focus-or-tab up";
        C-l = ":sh zellij ac move-focus-or-tab right";
        
        C-esc = [
          "goto_first_nonwhitespace"
          "select_mode"
          "extend_to_line_end"
          ":sh zellij ac move-focus-or-tab right"
          ":pipe-to sh -c 'zellij ac write-chars \"$(cat)\\n\"'"
          ":sh zellij ac move-focus-or-tab left"
          "move_visual_line_down"
          "goto_first_nonwhitespace"
          "collapse_selection"
          "normal_mode"
        ];
        
        C-space = [
          "select_mode"
          "extend_to_line_bounds"
          ":sh zellij ac move-focus-or-tab right"
          ":pipe-to sh -c 'zellij ac write-chars \"$(cat)\\n\"'"
          ":sh zellij ac move-focus-or-tab left"
          "move_visual_line_down"
          "goto_first_nonwhitespace"
          "collapse_selection"
          "normal_mode"
        ];
        
        C-a = {
          C-a = ":sh zellij ac toggle-floating-panes";
          h = ":sh zellij ac new-pane -d down";
          n = ":sh zellij ac new-pane";
          r = [
            ":sh zellij ac new-pane -d right -- ipython"
            ":sh zellij ac move-focus left"
          ];
          v = ":sh zellij ac new-pane -d right";
          z = ":sh zellij ac toggle-fullscreen";
        };
        
        C-t = {
          n = ":sh zellij ac new-tab";
        };
      };

      keys.insert = {
        C-esc = [
          "goto_first_nonwhitespace"
          "select_mode"
          "extend_to_line_end"
          ":sh zellij ac move-focus-or-tab right"
          ":pipe-to sh -c 'zellij ac write-chars \"$(cat)\\n\"'"
          ":sh zellij ac move-focus-or-tab left"
          "collapse_selection"
          "insert_mode"
        ];
        
        C-space = [
          "select_mode"
          "extend_to_line_bounds"
          ":sh zellij ac move-focus-or-tab right"
          ":pipe-to sh -c 'zellij ac write-chars \"$(cat)\\n\"'"
          ":sh zellij ac move-focus-or-tab left"
          "collapse_selection"
          "insert_mode"
        ];
      };

      keys.select = {
        C-space = [
          ":sh zellij ac move-focus-or-tab right"
          ":pipe-to sh -c 'rg -v \"^[[:space:]]*$\" | zellij ac write-chars \"$(cat)\\n\"'"
          ":sh zellij ac move-focus-or-tab left"
          "collapse_selection"
          "move_visual_line_down"
          "goto_first_nonwhitespace"
          "collapse_selection"
          "normal_mode"
        ];
      };
    };
    
    themes = {
      mocha = builtins.fromTOML (builtins.readFile ./helix-mocha-theme.toml);
    };
  };
}

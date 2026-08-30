{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    extraPackages = [ pkgs.wl-clipboard ];
    settings = {
      theme = "broken-pine";

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
        C-h = ":sh tmux select-pane -L";
        C-j = ":sh tmux select-pane -D";
        C-k = ":sh tmux select-pane -U";
        C-l = ":sh tmux select-pane -R";

        C-esc = [
          "goto_first_nonwhitespace"
          "select_mode"
          "extend_to_line_end"
          ":pipe-to sh -c 'tmux load-buffer -; tmux paste-buffer -t {right-of}; tmux send-keys -t {right-of} Enter'"
          "move_visual_line_down"
          "goto_first_nonwhitespace"
          "collapse_selection"
          "normal_mode"
        ];

        C-g = [
          "select_mode"
          "extend_to_line_bounds"
          ":pipe-to sh -c 'tmux load-buffer -; tmux paste-buffer -t {right-of}; tmux send-keys -t {right-of} Enter'"
          "move_visual_line_down"
          "goto_first_nonwhitespace"
          "collapse_selection"
          "normal_mode"
        ];

        C-a = {
          C-a = ":sh tmux display-popup -E -w 80% -h 80% -d '#{pane_current_path}'";
          h = ":sh tmux split-window -v -c '#{pane_current_path}'";
          n = ":sh tmux split-window -c '#{pane_current_path}'";
          r = [
            ":sh tmux split-window -h -d -c '#{pane_current_path}' ipython"
          ];
          v = ":sh tmux split-window -h -c '#{pane_current_path}'";
          z = ":sh tmux resize-pane -Z";
        };

        C-t = {
          n = ":sh tmux new-window -c '#{pane_current_path}'";
        };
      };

      keys.insert = {
        C-esc = [
          "goto_first_nonwhitespace"
          "select_mode"
          "extend_to_line_end"
          ":pipe-to sh -c 'tmux load-buffer -; tmux paste-buffer -t {right-of}; tmux send-keys -t {right-of} Enter'"
          "collapse_selection"
          "insert_mode"
        ];

        C-g = [
          "select_mode"
          "extend_to_line_bounds"
          ":pipe-to sh -c 'tmux load-buffer -; tmux paste-buffer -t {right-of}; tmux send-keys -t {right-of} Enter'"
          "collapse_selection"
          "insert_mode"
        ];
      };

      keys.select = {
        y = [
          "yank"
          "yank_to_clipboard"
          "normal_mode"
        ];

        C-g = [
          ":pipe-to sh -c 'rg -v \"^[[:space:]]*$\" | tmux load-buffer -; tmux paste-buffer -t {right-of}; tmux send-keys -t {right-of} Enter'"
          "collapse_selection"
          "move_visual_line_down"
          "goto_first_nonwhitespace"
          "collapse_selection"
          "normal_mode"
        ];
      };
    };

    themes = {
      broken-pine = builtins.fromTOML (builtins.readFile ../themes/broken-pine-helix.toml);
    };
  };
}

{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        ratio = [ 1 3 4 ];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        show_hidden = false;
        show_symlink = true;
        linemode = "size";
      };

      preview = {
        max_width = 1000;
        max_height = 1000;
      };

      opener = {
        edit = [
          { run = ''helix "$@"''; desc = "Edit in Helix"; block = true; }
        ];
        open = [
          { run = ''xdg-open "$@"''; desc = "Open"; }
        ];
        play = [
          { run = ''mpv "$@"''; desc = "Play"; orphan = true; }
        ];
      };

      open = {
        rules = [
          { mime = "text/*"; use = "edit"; }
          { mime = "video/*"; use = "play"; }
          { mime = "audio/*"; use = "play"; }
          { mime = "*"; use = "open"; }
        ];
      };
    };

    keymap = {
      manager.prepend_keymap = [
        { on = [ "<Esc>" ]; run = "escape"; desc = "Exit visual mode, clear selected, or cancel"; }
        { on = [ "." ]; run = "hidden toggle"; desc = "Toggle hidden files"; }
        { on = [ "g" "m" ]; run = "cd /run/media/$USER"; desc = "Go to mounted media"; }
      ];
    };

    theme = {
      manager = {
        cwd = { fg = "cyan"; };
        hovered = { fg = "black"; bg = "lightblue"; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = "yellow"; italic = true; };
        find_position = { fg = "magenta"; bg = "reset"; italic = true; };
        marker_selected = { fg = "lightgreen"; bg = "lightgreen"; };
        marker_copied = { fg = "lightyellow"; bg = "lightyellow"; };
        marker_cut = { fg = "lightred"; bg = "lightred"; };
        tab_active = { fg = "black"; bg = "lightblue"; };
        tab_inactive = { fg = "white"; bg = "darkgray"; };
        tab_width = 1;
        border_symbol = "│";
        border_style = { fg = "gray"; };
      };

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = "gray"; bg = "gray"; };
        mode_normal = { fg = "black"; bg = "lightblue"; bold = true; };
        mode_select = { fg = "black"; bg = "lightgreen"; bold = true; };
        mode_unset = { fg = "black"; bg = "lightmagenta"; bold = true; };
        progress_label = { fg = "white"; bold = true; };
        progress_normal = { fg = "blue"; bg = "black"; };
        progress_error = { fg = "red"; bg = "black"; };
        permissions_t = { fg = "lightgreen"; };
        permissions_r = { fg = "lightyellow"; };
        permissions_w = { fg = "lightred"; };
        permissions_x = { fg = "lightcyan"; };
        permissions_s = { fg = "darkgray"; };
      };

      select = {
        border = { fg = "blue"; };
        active = { fg = "magenta"; };
        inactive = { fg = "darkgray"; };
      };

      input = {
        border = { fg = "blue"; };
        title = { fg = "white"; };
        value = { fg = "magenta"; };
        selected = { reversed = true; };
      };

      completion = {
        border = { fg = "blue"; };
        active = { bg = "darkgray"; };
        inactive = { fg = "white"; };
      };

      tasks = {
        border = { fg = "blue"; };
        title = { fg = "white"; };
        hovered = { underline = true; };
      };

      which = {
        cols = 3;
        mask = { bg = "black"; };
        cand = { fg = "lightcyan"; };
        rest = { fg = "darkgray"; };
        desc = { fg = "magenta"; };
        separator = "  ";
        separator_style = { fg = "darkgray"; };
      };

      help = {
        on = { fg = "magenta"; };
        exec = { fg = "cyan"; };
        desc = { fg = "gray"; };
        hovered = { bg = "darkgray"; bold = true; };
        footer = { fg = "black"; bg = "white"; };
      };

      filetype = {
        rules = [
          { mime = "image/*"; fg = "cyan"; }
          { mime = "video/*"; fg = "yellow"; }
          { mime = "audio/*"; fg = "magenta"; }
          { mime = "application/zip"; fg = "red"; }
          { mime = "application/gzip"; fg = "red"; }
          { mime = "application/x-tar"; fg = "red"; }
          { mime = "application/x-bzip"; fg = "red"; }
          { mime = "application/x-bzip2"; fg = "red"; }
          { mime = "application/x-7z-compressed"; fg = "red"; }
          { mime = "application/x-rar"; fg = "red"; }
          { name = "*"; fg = "white"; }
          { name = "*/"; fg = "blue"; }
        ];
      };
    };
  };

  # Essential packages for file management
  home.packages = with pkgs; [
    file                 # File type identification
    ffmpegthumbnailer    # Video thumbnails
    poppler-utils        # PDF preview
    fd                   # Better find
    ripgrep              # Better grep
    fzf                  # Fuzzy finder
    zoxide               # Smart cd
  ];

  # Enable udiskie for automatic disk mounting
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
  };
}

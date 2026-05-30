{ pkgs, ... }:
let
  brokenPine = import ./broken-pine.nix;
in
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
        cwd = { fg = brokenPine.blue; };
        hovered = { fg = brokenPine.background; bg = brokenPine.blue; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = brokenPine.yellow; italic = true; };
        find_position = { fg = brokenPine.magenta; bg = "reset"; italic = true; };
        marker_selected = { fg = brokenPine.green; bg = brokenPine.green; };
        marker_copied = { fg = brokenPine.yellow; bg = brokenPine.yellow; };
        marker_cut = { fg = brokenPine.red; bg = brokenPine.red; };
        tab_active = { fg = brokenPine.background; bg = brokenPine.blue; };
        tab_inactive = { fg = brokenPine.text; bg = brokenPine.surfaceActive; };
        tab_width = 1;
        border_symbol = "│";
        border_style = { fg = brokenPine.border; };
      };

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = brokenPine.border; bg = brokenPine.border; };
        mode_normal = { fg = brokenPine.background; bg = brokenPine.blue; bold = true; };
        mode_select = { fg = brokenPine.background; bg = brokenPine.green; bold = true; };
        mode_unset = { fg = brokenPine.background; bg = brokenPine.magenta; bold = true; };
        progress_label = { fg = brokenPine.text; bold = true; };
        progress_normal = { fg = brokenPine.blue; bg = brokenPine.background; };
        progress_error = { fg = brokenPine.red; bg = brokenPine.background; };
        permissions_t = { fg = brokenPine.green; };
        permissions_r = { fg = brokenPine.yellow; };
        permissions_w = { fg = brokenPine.red; };
        permissions_x = { fg = brokenPine.blue; };
        permissions_s = { fg = brokenPine.mutedAlt; };
      };

      select = {
        border = { fg = brokenPine.blue; };
        active = { fg = brokenPine.magenta; };
        inactive = { fg = brokenPine.mutedAlt; };
      };

      input = {
        border = { fg = brokenPine.blue; };
        title = { fg = brokenPine.text; };
        value = { fg = brokenPine.magenta; };
        selected = { reversed = true; };
      };

      completion = {
        border = { fg = brokenPine.blue; };
        active = { bg = brokenPine.surfaceActive; };
        inactive = { fg = brokenPine.text; };
      };

      tasks = {
        border = { fg = brokenPine.blue; };
        title = { fg = brokenPine.text; };
        hovered = { underline = true; };
      };

      which = {
        cols = 3;
        mask = { bg = brokenPine.background; };
        cand = { fg = brokenPine.blue; };
        rest = { fg = brokenPine.mutedAlt; };
        desc = { fg = brokenPine.magenta; };
        separator = "  ";
        separator_style = { fg = brokenPine.mutedAlt; };
      };

      help = {
        on = { fg = brokenPine.magenta; };
        exec = { fg = brokenPine.blue; };
        desc = { fg = brokenPine.muted; };
        hovered = { bg = brokenPine.surfaceActive; bold = true; };
        footer = { fg = brokenPine.background; bg = brokenPine.text; };
      };

      filetype = {
        rules = [
          { mime = "image/*"; fg = brokenPine.blue; }
          { mime = "video/*"; fg = brokenPine.yellow; }
          { mime = "audio/*"; fg = brokenPine.magenta; }
          { mime = "application/zip"; fg = brokenPine.red; }
          { mime = "application/gzip"; fg = brokenPine.red; }
          { mime = "application/x-tar"; fg = brokenPine.red; }
          { mime = "application/x-bzip"; fg = brokenPine.red; }
          { mime = "application/x-bzip2"; fg = brokenPine.red; }
          { mime = "application/x-7z-compressed"; fg = brokenPine.red; }
          { mime = "application/x-rar"; fg = brokenPine.red; }
          { name = "*"; fg = brokenPine.text; }
          { name = "*/"; fg = brokenPine.blue; }
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

{ pkgs, ... }:
let
  vesper = import ../themes/vesper.nix;
in
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
    extraPackages = [ ];

    settings = {
      mgr = {
        ratio = [
          1
          3
          4
        ];
        sort_by = "mtime";
        sort_sensitive = false;
        sort_reverse = true;
        sort_dir_first = true;
        show_hidden = false;
        show_symlink = true;
        linemode = "size";
      };

      preview = {
        max_width = 4096;
        max_height = 4096;
        image_filter = "lanczos3";
        image_quality = 90;
      };

      opener = {
        edit = [
          {
            run = ''helix %s'';
            desc = "Edit in Helix";
            block = true;
          }
        ];
        zed = [
          {
            run = ''zeditor %s'';
            desc = "Edit in Zed";
            orphan = true;
          }
        ];
        open = [
          {
            run = ''xdg-open %s1'';
            desc = "Open";
            orphan = true;
          }
        ];
        pdf = [
          {
            run = ''${pkgs.papers}/bin/papers %s'';
            desc = "Open in Papers";
            orphan = true;
          }
        ];
        spreadsheet = [
          {
            run = ''visigrid-open %s'';
            desc = "Open in VisiGrid";
            orphan = true;
          }
        ];
        office = [
          {
            run = ''onlyoffice-desktopeditors %s'';
            desc = "Open in OnlyOffice";
            orphan = true;
          }
        ];
        play = [
          {
            run = ''mpv %s'';
            desc = "Play";
            orphan = true;
          }
        ];
      };

      open = {
        rules = [
          {
            mime = "application/pdf";
            use = "pdf";
          }
          {
            url = "*.{csv,tsv,xlsx,xls,xlsb,ods,sheet}";
            use = "spreadsheet";
          }
          {
            mime = "application/vnd.openxmlformats-officedocument.*";
            use = "office";
          }
          {
            mime = "application/vnd.ms-*";
            use = "office";
          }
          {
            mime = "application/msword";
            use = "office";
          }
          {
            url = "*.json";
            use = [
              "zed"
              "edit"
            ];
          }
          {
            mime = "text/*";
            use = [
              "zed"
              "edit"
            ];
          }
          {
            mime = "video/*";
            use = "play";
          }
          {
            mime = "audio/*";
            use = "play";
          }
          {
            mime = "*";
            use = "open";
          }
        ];
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "<Esc>" ];
          run = "escape";
          desc = "Exit visual mode, clear selected, or cancel";
        }
        {
          on = [ "." ];
          run = "hidden toggle";
          desc = "Toggle hidden files";
        }
        {
          on = [
            "g"
            "m"
          ];
          run = "cd /run/media/$USER";
          desc = "Go to mounted media";
        }
      ];
    };

    theme = {
      app.overall = {
        bg = vesper.background;
      };

      mgr = {
        cwd = {
          fg = vesper.yellow;
        };
        find_keyword = {
          fg = vesper.yellow;
          bold = true;
          italic = true;
          underline = true;
        };
        find_position = {
          fg = vesper.green;
          bg = "reset";
          bold = true;
          italic = true;
        };
        symlink_target = {
          fg = vesper.muted;
          italic = true;
        };
        marker_selected = {
          fg = vesper.green;
          bg = vesper.green;
        };
        marker_marked = {
          fg = vesper.yellow;
          bg = vesper.yellow;
        };
        marker_copied = {
          fg = vesper.green;
          bg = vesper.green;
        };
        marker_cut = {
          fg = vesper.red;
          bg = vesper.red;
        };
        marker_symbol = "│";
        count_copied = {
          fg = vesper.background;
          bg = vesper.green;
        };
        count_cut = {
          fg = vesper.background;
          bg = vesper.red;
        };
        count_selected = {
          fg = vesper.background;
          bg = vesper.yellow;
        };
        border_symbol = "│";
        border_style = {
          fg = vesper.border;
        };
        syntect_theme = "${../themes/vesper-bat.tmTheme}";
      };

      tabs = {
        active = {
          fg = vesper.background;
          bg = vesper.yellow;
          bold = true;
        };
        inactive = {
          fg = vesper.muted;
          bg = vesper.surface;
        };
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };

      mode = {
        normal_main = {
          fg = vesper.background;
          bg = vesper.yellow;
          bold = true;
        };
        normal_alt = {
          fg = vesper.yellow;
          bg = vesper.surfaceVariant;
        };
        select_main = {
          fg = vesper.background;
          bg = vesper.green;
          bold = true;
        };
        select_alt = {
          fg = vesper.green;
          bg = vesper.surfaceVariant;
        };
        unset_main = {
          fg = vesper.background;
          bg = vesper.red;
          bold = true;
        };
        unset_alt = {
          fg = vesper.red;
          bg = vesper.surfaceVariant;
        };
      };

      indicator = {
        parent = {
          fg = vesper.muted;
        };
        current = {
          fg = vesper.green;
          bg = "reset";
        };
        preview = {
          underline = true;
        };
        padding = {
          open = "";
          close = "";
        };
      };

      status = {
        overall = {
          fg = vesper.muted;
          bg = vesper.background;
        };
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };
        perm_sep = {
          fg = vesper.disabled;
        };
        perm_type = {
          fg = vesper.green;
        };
        perm_read = {
          fg = vesper.yellow;
        };
        perm_write = {
          fg = vesper.red;
        };
        perm_exec = {
          fg = vesper.green;
        };
        progress_label = {
          fg = vesper.text;
          bold = true;
        };
        progress_normal = {
          fg = vesper.green;
          bg = vesper.background;
        };
        progress_error = {
          fg = vesper.red;
          bg = vesper.background;
        };
      };

      pick = {
        border = {
          fg = vesper.yellow;
        };
        active = {
          fg = vesper.yellow;
          bold = true;
        };
        inactive = {
          fg = vesper.muted;
        };
      };

      input = {
        border = {
          fg = vesper.yellow;
        };
        title = {
          fg = vesper.text;
        };
        value = {
          fg = vesper.green;
        };
        selected = {
          reversed = true;
        };
      };

      cmp = {
        border = {
          fg = vesper.yellow;
        };
        active = {
          fg = vesper.yellow;
          bg = vesper.surfaceVariant;
          bold = true;
        };
        inactive = {
          fg = vesper.text;
        };
      };

      tasks = {
        border = {
          fg = vesper.yellow;
        };
        title = {
          fg = vesper.text;
        };
        hovered = {
          fg = vesper.yellow;
          bold = true;
        };
      };

      which = {
        cols = 3;
        border = {
          fg = vesper.yellow;
        };
        mask = {
          bg = vesper.background;
        };
        cand = {
          fg = vesper.green;
        };
        rest = {
          fg = vesper.mutedAlt;
        };
        desc = {
          fg = vesper.yellow;
        };
        separator = "  ";
        separator_style = {
          fg = vesper.disabled;
        };
      };

      help = {
        border = {
          fg = vesper.yellow;
        };
        chord = {
          fg = vesper.green;
        };
        action = {
          fg = vesper.muted;
        };
        hovered = {
          fg = vesper.yellow;
          bg = vesper.surfaceVariant;
          bold = true;
        };
      };

      filetype.rules = [
        {
          mime = "**/image/*";
          fg = vesper.green;
        }
        {
          mime = "**/{audio,video}/*";
          fg = vesper.yellow;
        }
        {
          mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          fg = vesper.red;
        }
        {
          mime = "**/application/{pdf,doc,rtf}";
          fg = vesper.green;
        }
        {
          url = "*";
          is = "orphan";
          fg = vesper.red;
        }
        {
          url = "*";
          is = "exec";
          fg = vesper.green;
        }
        {
          url = "*/";
          fg = vesper.yellow;
        }
      ];
    };
  };

  # Essential packages for file management
  home.packages = with pkgs; [
    file # File type identification
    ffmpegthumbnailer # Video thumbnails
    poppler-utils # PDF preview
    fd # Better find
    ripgrep # Better grep
    fzf # Fuzzy finder
    zoxide # Smart cd
  ];

  # Enable udiskie for automatic disk mounting
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
  };
}

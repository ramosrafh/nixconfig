{ pkgs, ... }:
let
  brokenPine = import ../themes/broken-pine.nix;
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    newSession = false;
    prefix = "C-Space";
    sensibleOnTop = false;
    terminal = "tmux-256color";

    extraConfig = ''
      set -g default-shell "${pkgs.fish}/bin/fish"
      set -g default-command "${pkgs.fish}/bin/fish"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -as terminal-features ",alacritty:RGB"

      set -g renumber-windows on
      set -g pane-base-index 1
      set -g automatic-rename on
      set -g automatic-rename-format '#{pane_current_command}'
      set -g allow-rename on
      set -g allow-set-title on
      set -g set-titles on
      set -g set-titles-string '#S:#I:#W'

      set -g status on
      set -g status-position top
      set -g status-interval 2
      set -g status-justify left
      set -g status-left-length 0
      set -g status-right-length 20
      set -g status-style 'bg=${brokenPine.background},fg=${brokenPine.muted}'
      set -g status-left ""
      set -g status-right '#[fg=${brokenPine.blue}] %Y-%m-%d '

      set -g window-status-separator ' '
      set -g window-status-format '#[fg=${brokenPine.muted}] #I: #{?#{==:#{pane_current_command},fish},#W,#{?pane_title,#{pane_title},#W}} '
      set -g window-status-current-format '#[bg=${brokenPine.yellow},fg=${brokenPine.background},bold] #I: #{?#{==:#{pane_current_command},fish},#W,#{?pane_title,#{pane_title},#W}} '
      set -g window-status-activity-style 'fg=${brokenPine.orange},bold'

      set -g pane-border-style 'fg=${brokenPine.surfaceActive}'
      set -g pane-active-border-style 'fg=${brokenPine.yellow}'
      set -g message-style 'bg=${brokenPine.surfaceActive},fg=${brokenPine.textAlt}'
      set -g message-command-style 'bg=${brokenPine.surfaceActive},fg=${brokenPine.yellow}'
      set -g mode-style 'bg=${brokenPine.blue},fg=${brokenPine.background}'

      unbind '"'
      unbind %
      bind - split-window -v -c '#{pane_current_path}'
      bind | split-window -h -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'
      bind r command-prompt -I '#W' 'rename-window "%%"'
      bind z resize-pane -Z
      bind p display-popup -E -w 80% -h 80% -d '#{pane_current_path}'

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind H resize-pane -L 5
      bind J resize-pane -D 5
      bind K resize-pane -U 5
      bind L resize-pane -R 5

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      bind -n M-n split-window -c '#{pane_current_path}'

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
    '';
  };
}

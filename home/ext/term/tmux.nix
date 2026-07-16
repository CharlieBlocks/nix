{ pkgs, shell }: {

    programs.tmux = {
        enable = true;
        shell = "${shell}";
        newSession = true;
        disableConfirmationPrompt = true;
        keyMode = "vi";

        terminal = "tmux-256color";

        historyLimit = 1000000;
        plugins = [
            pkgs.tmuxPlugins.yank
        ];

        prefix-key="C-Space";

        extraConfig = ''
            # Prefix bindings
            unbind C-b
            set-option -g prefix C-Space
            bind-key C-Space send-prefix

            # Enable mouse input
            set -g mouse on
            set-option -sa terminal-overrides ",xterm*:Tc"

            ## Key Bindings ##
            set-option -g allow-rename off

            # New window
            unbind n
            bind n new-window

            unbind C
            bind C kill-window

            # bind -n C-l select-window -n
            # bind -n C-h select-window -p

            # Pane split commands
            # unbind '"'
            # unbind %
            # unbind v
            # unbind h
            # bind h split-window -h
            # bind v split-window -v

            # Pane navigation
            # bind -n M-j select-pane -D
            # bind -n M-k select-pane -U
            # bind -n M-l select-pane -R
            # bind -n M-h select-pane -L

            # Close panes
            unbind x
            bind-key x kill-pane


            # Copy mode bindings
            setw -g mode-keys vi
            bind-key -T copy-mode-vi h send-keys -X cursor-left
            bind-key -T copy-mode-vi j send-keys -X cursor-down
            bind-key -T copy-mode-vi k send-keys -X cursor-up
            bind-key -T copy-mode-vi l send-keys -X cursor-right
            bind-key -T copy-mode-vi v send-keys -X begin-selection

            # Theme
            thm_bg=${config.scheme.withHashtag.base00}
            thm_fg=${config.scheme.withHashtag.base05}
            thm_cyan=${config.scheme.withHashtag.base15}
            thm_black=${config.scheme.withHashtag.base01}
            thm_gray=${config.scheme.withHashtag}
            thm_magenta=${config.scheme.withHashtag.base0E}
            thm_pink=${config.scheme.withHashtag.base17}
            thm_red=${config.scheme.withHashtag.base08}
            thm_green=${config.scheme.withHashtag.base0B}
            thm_yellow=${config.scheme.withHashtag.base0A}
            thm_blue=${config.scheme.withHashtag.base0D}
            thm_orange=${config.scheme.withHashtag.base09}
            thm_black4=${config.scheme.withHashtag.base00}

            set -g visual-activity off
            set -g visual-bell off
            set -g visual-silence off
            setw -g monitor-activity off
            set -g bell-action none

            # Pane Style
            set -g window-style=$thm_black
            set -g window-active-style = bg=$thm_bg

            # Pane Border
            set -g pane-border-style bg=$thm_black
            set -g pane-active-border-style bg=$thm_bg,fg=white

            # Status bar
            set -g status-position bottom
            set -g window-status-current-style fg=black,bg=red
            set -g window-status-current-format ' #I #W #F '

            set -g window-status-style fg=red,bg=$thm_bg
            set -g window-status-format " #I #[fg-white]#W #[fg=yellow]#{s/-//:window_flags} "
        '';
    };

}

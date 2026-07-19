{ pkgs, ... }: {

    home.packages = [ pkgs.starship ];
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        enableTransience = true;

        settings = {
            "$schema" = "https://starship.rs/config-schema.json";

	add_newline = false;

	format = "($nix_shell$containers$fill$git_metrics\n)$cmd_duration$hostname$sudo$username$character";

	right_format = ''$directory$vcs$time'';

	fill.symbol = " ";

	character = {
	    format = "$symbol ";
	    success_symbol = "[\\$](bold green)";
	    error_symbol = "[✘](bold red)";
	};

	vcs = {
	    order = [ "git" ];
	    git_modules = "$git_branch$git_status";
	};

	git_status = {
	    # latest(-4,+2) [+4 -2 ~1]
	    format = "$ahead_behind([\\[$staged$deleted$modified$conflicted$stashed\\]](bold italic bright-green))";
	    ahead="[\\([+\${count}](italic blue)\\)](italic gray)";
	    behind="[\\([-\${count}](italic dark-blue)\\)](italic gray)";
	    diverged="[(](italic gray)[+\${ahead_count}](italic blue)[, ](italic gray)[-\${behind_count}](italic dark-blue)[)](italic gray)";
	    conflicted = "!";
	    untracked = "?\${count}";
	    modified = "~\${count}";
	    staged = "+\${count}";
	    renamed = "";
	    deleted = "-\${count}";
	};

	sudo = {
	    format = "[$symbol]($style)";
	    style = "bold italic bright-purple";
	    symbol = "󰦞 ";
	    disabled = false;
	};
        };
    };

}

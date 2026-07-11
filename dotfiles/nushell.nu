$env.config.buffer_editor = "vim"
$env.config.show_banner = false


# Environment Vars
# ANDROID_HOME
# HF_HOME

{ ||
    if (which direnv | is-empty) {
        return
    }

    direnv export json | from json | default {} | load-env
}

function tmux-sessionizer
    set -l selected
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set selected (
            begin
                find \
                    ~/Code \
                    ~/Projects \
                    -mindepth 1 \
                    -maxdepth 1 \
                    -type d \
                    2>/dev/null
            end | fzf --height 40% --reverse
        )
    end

    if test -z "$selected"
        if status is-interactive
            commandline -f repaint
        end
        return 0
    end

    set -l selected_name (path basename "$selected" | string replace -a '.' '_')

    # No tmux server and we're not already inside tmux.
    if not set -q TMUX; and not tmux has-session 2>/dev/null
        tmux new-session -s "$selected_name" -c "$selected"
        commandline -f repaint
        return 0
    end

    # Create the session if it doesn't already exist.
    if not tmux has-session -t "$selected_name" 2>/dev/null
        tmux new-session -ds "$selected_name" -c "$selected"
    end

    # Attach/switch depending on whether we're already inside tmux.
    if set -q TMUX
        tmux switch-client -t "$selected_name"
    else
        tmux attach-session -t "$selected_name"
        commandline -f repaint
    end
end


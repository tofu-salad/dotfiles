function nix_shell_info
    if test -n "$IN_NIX_SHELL"
        echo -n (set_color blue)"<nix-shell> "(set_color normal)
    else if string match -q "/nix/store*" $PATH[1]
        echo -n (set_color blue)"<nix-shell> "(set_color normal)
    end
end

function fish_prompt
    set -l last_status $status
    set -l stat
    set -l pwd
    # Check if it's a transient or final prompt
    if contains -- --final-rendering $argv
        set pwd (path basename $PWD)
    else
        set pwd (prompt_pwd)
        # Prompt status only if it's not 0
        if test $last_status -ne 0
            set stat (set_color red)"[$last_status]"(set_color normal)
        end
    end

    string join '' -- (nix_shell_info) (set_color green) $pwd (set_color normal) $stat (fish_vcs_prompt) ' $ '
end

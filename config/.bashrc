case $- in
    *i*) ;;
    *) return ;;
esac

if [[ $SHLVL -le 2 ]] && [[ $(cat /proc/$PPID/comm 2>/dev/null) != "fish" ]]; then
    if fish_path=$(command -v fish 2>/dev/null); then
        SHELL=$fish_path exec "$fish_path"
    fi
fi

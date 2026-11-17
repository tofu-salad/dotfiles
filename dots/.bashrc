case $- in
    *i*) ;;
    *) return ;;
esac

if [[ $SHLVL -le 2 ]] && [[ $(cat /proc/$PPID/comm 2>/dev/null) != "fish" ]]; then
    if fish_path=$(command -v fish 2>/dev/null); then
        SHELL=$fish_path exec "$fish_path"
    fi
fi

HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend checkwinsize

__prompt() {
  local ec=$?
  local reset='\[\e[0m\]' red='\[\e[31m\]' yellow='\[\e[33m\]' lblue='\[\e[94m\]' gray='\[\e[90m\]'

  local nix=""
  [[ -n $IN_NIX_SHELL ]] && nix="${lblue}(nix:${IN_NIX_SHELL})${reset} "

  local git="" branch
  branch=$(git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  [[ -n $branch ]] && git=" ${gray}${branch}${reset}"

  local status=""
  (( ec != 0 )) && status=" ${red}[${ec}]${reset}"

  PS1="${nix}${yellow}\w${reset}${git}${status} \$ "
}
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}__prompt"

#
# zshrc file. Created April 27, 2025
#
# With Autosuggestions, Syntax highlighting, Autocompletion, FZF integration and pur Prompt
# 
# Install zsh, fd-find, fzf, git, wget, curl
#
# Install zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
#
# Install zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
#
# Install FZF 
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install
#
# Install Pure Prompt
# git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
#
# Reload the shell
# source ~/.zshrc
#
#

export TERM=xterm-256color

# --- Basic Settings ---
setopt PROMPT_SUBST
setopt AUTO_CD             # cd into directory by just typing its name
setopt HIST_IGNORE_DUPS    # Don't store duplicate history entries
setopt SHARE_HISTORY       # Share history between all sessions

export EDITOR="nvim"
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=5000

# --- Pure Prompt ---
#fpath+=$(npm root --prefix "$HOME" --global)/pure
#autoload -U promptinit; promptinit
#prompt pure
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
#
# optionally define some options
PURE_CMD_MAX_EXEC_TIME=10
PURE_PROMPT_SYMBOL="> "
# PURE_PROMPT_SYMBOL="▶ "
#
# Git Functions
PURE_GIT_DOWN_ARROW=""↓""
PURE_GIT_UP_ARROW=""↑""
PURE_GIT_STASh_SYMBOL=""⚑""
#
# change the color mode
zstyle :prompt:pure:path color white
#
# # change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color cyan
#
# # turn on git stash status
zstyle :prompt:pure:git:stash show yes

prompt pure

# --- Autosuggestions ---
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Syntax Highlighting ---
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- FZF Integration ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# History settings
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt append_history
setopt hist_ignore_dups
setopt share_history

# --- Completion system ---
autoload -Uz compinit
compinit

# --- FZF Key Bindings (Optional) ---
export FZF_DEFAULT_COMMAND='fd --type f'   # If you have `fd`, otherwise comment this
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# --- Optional: Improve completion ---
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# A few aliases for exa, a ls replacement
alias l="exa --sort Name"
alias ls="exa --sort Name"
alias ll="exa --sort Name --long"
alias la="exa --sort Name --long --all"
alias lr="exa --sort Name --long --recurse"
alias lra="exa --sort Name --long --recurse --all"
alias lt="exa --sort Name --long --tree"
alias lta="exa --sort Name --long --tree --all"

alias n="nvim"

#
# Functions
#
function cheat() { # lookup cheats for certain command, e.i. cheat tar
        if [ "$2" ]; then
            curl "https://cheat.sh/$1/$2+$3+$4+$5+$6+$7+$8+$9+$10"
        else
            curl "https://cheat.sh/$1"
        fi
}


function speedtest() { # as the name says, it will test your up- and download speed
        curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
}


function dadjoke() { # no comment required ;) 
            curl https://icanhazdadjoke.com
}


function acp() { # acp "a commit message"
    git add .
    git commit -m "$1"
    git push
}


function 2html() { # converts plain ascii test into html, with highlighting
    vim -u NONE -n -c ':syntax on' -c ':so $VIMRUNTIME/syntax/2html.vim' -c':wqa' $1 &>/dev/null 
}
 

function vman() { # use vim as man page reader - colors...
    man $* | col -b | view -c 'set ft=man nomod nolist' - 
}

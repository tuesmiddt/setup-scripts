# source <(antibody init)

export ZSH="$HOME/.oh-my-zsh"

source ~/.zsh_plugins.sh

# antibody bundle < ~/.zsh_plugins.txt

# NVM is hella slow so we do this
# See: https://github.com/nvm-sh/nvm/issues/1277#issuecomment-536218082
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
    mkdir $ZSH_CACHE_DIR
fi

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export GOPATH="$HOME"

alias v="nvim"
alias t="tmux"
alias o="xdg-open"
alias py="python3"
alias xclip='xargs echo -n | xclip -selection clipboard'

alias asdfg=". /opt/asdf-vm/asdf.sh"

autoload -U promptinit; promptinit
prompt pure
PROMPT='%F{blue}%* '$PROMPT

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/duck/google-cloud-sdk/path.zsh.inc' ]; then . '/home/duck/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/duck/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/duck/google-cloud-sdk/completion.zsh.inc'; fi

PATH="/home/duck/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/duck/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/duck/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/duck/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/duck/perl5"; export PERL_MM_OPT;

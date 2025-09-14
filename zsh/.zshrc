#!/usr/bin/env zsh
# Optimized .zshrc for fast shell startup
# Enable profiling: uncomment next line and zprof at end
# zmodload zsh/zprof

# ============================================================================
# INSTANT - Core Settings (must be fast)
# ============================================================================
export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim

# Basic PATH setup - do once, early
typeset -U PATH path  # Unique entries only
path=(
  $HOME/.proto/shims
  $HOME/.proto/bin
  $HOME/.local/bin
  $HOME/.deno/bin
  $HOME/Library/pnpm
  $HOME/.cargo/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /opt/homebrew/opt/llvm/bin
  /opt/homebrew/opt/binutils/bin
  /opt/homebrew/opt/ruby/bin
  /opt/homebrew/opt/postgresql@16/bin
  $path
)

# ============================================================================
# INSTANT - Fast Aliases (no external commands)
# ============================================================================
alias v=nvim
alias py=python
alias p=pnpm
alias lg=lazygit
alias printpath="echo \$PATH | tr ':' '\n'"
alias wip="git add -A && git commit -m 'wip' && git push"

# Fast functions
mkcd() { mkdir -p "$1" && cd "$1"; }

# Quick directory jumps
alias cdd='cd ~/Development'
alias cdf='cd ~/dotfiles'

# Smart config/dev navigation with fzf
# Type 'cf' to fuzzy jump to any config dir
cf() {
  local dir
  dir=$(fd --type d --hidden --exclude .git --max-depth 3 . ~/dotfiles 2>/dev/null | fzf --preview 'tree -C -L 1 {}') && cd "$dir"
}

# Type 'dev' to fuzzy jump to any Development project
dev() {
  local dir
  dir=$({ fd --type d --max-depth 4 . ~/Development 2>/dev/null; \
          fd --type d --max-depth 2 . ~/AndroidStudioProjects 2>/dev/null; \
          fd --type d --max-depth 2 . ~/golioth/apps 2>/dev/null; } | \
          fzf --preview 'tree -C -L 1 {}') && cd "$dir"
}

# Global directory shortcuts (cd from anywhere)
hash -d dev=~/Development
hash -d dot=~/dotfiles
# Now you can use: cd ~config/nvim, cd ~dev/project, etc.

# ============================================================================
# FAST - Zsh Options & Completion (built-in, fast)
# ============================================================================
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories on every cd
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt HIST_IGNORE_DUPS     # Don't record duplicate commands
setopt HIST_IGNORE_SPACE    # Don't record commands starting with space
setopt SHARE_HISTORY        # Share history between sessions
setopt EXTENDED_HISTORY     # Record timestamp in history

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Custom key bindings
# Ctrl+U to jump to Development projects
dev-widget() {
  local dir
  dir=$({ fd --type d --max-depth 4 . ~/Development 2>/dev/null; \
          fd --type d --max-depth 2 . ~/AndroidStudioProjects 2>/dev/null; \
          fd --type d --max-depth 2 . ~/golioth/apps 2>/dev/null; } | \
          fzf --preview 'tree -C -L 1 {}')
  if [[ -n $dir ]]; then
    cd "$dir"
    zle reset-prompt
  fi
}
zle -N dev-widget
bindkey '^U' dev-widget

# Ctrl+V to jump to Development projects and open in vim
dev-vim-widget() {
  local dir
  dir=$({ fd --type d --max-depth 4 . ~/Development 2>/dev/null; \
          fd --type d --max-depth 2 . ~/AndroidStudioProjects 2>/dev/null; \
          fd --type d --max-depth 2 . ~/golioth/apps 2>/dev/null; } | \
          fzf --preview 'tree -C -L 1 {}')
  if [[ -n $dir ]]; then
    cd "$dir"
    BUFFER="nvim ."
    zle accept-line
  fi
}
zle -N dev-vim-widget
bindkey '^V' dev-vim-widget

# Alt+V to search and open files in Development projects
dev-file-widget() {
  local file
  file=$({ fd --type f --max-depth 5 . ~/Development 2>/dev/null; \
           fd --type f --max-depth 3 . ~/AndroidStudioProjects 2>/dev/null; \
           fd --type f --max-depth 3 . ~/golioth/apps 2>/dev/null; } | \
           fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')
  if [[ -n $file ]]; then
    BUFFER="nvim $file"
    zle accept-line
  fi
}
zle -N dev-file-widget
bindkey '\ev' dev-file-widget  # Alt+V

# Ctrl+P to jump to dotfiles (optional, remove if you want default behavior)
dot-widget() {
  local dir
  dir=$(fd --type d --hidden --exclude .git --max-depth 3 . ~/dotfiles 2>/dev/null | fzf --preview 'tree -C -L 1 {}')
  if [[ -n $dir ]]; then
    cd "$dir"
    zle reset-prompt
  fi
}
zle -N dot-widget
bindkey '^P' dot-widget

# Add brew completions to FPATH before compinit
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Basic completion (fast, built-in)
autoload -Uz compinit
# Only check for new completions once a day
if [[ ! -f ~/.zcompdump || ~/.zcompdump -nt /usr/share/zsh ]] || 
   [[ $(find ~/.zcompdump -mtime +1 -print 2>/dev/null) ]]; then
  compinit
else
  compinit -C  # Skip security check for faster startup
fi

# Completion options
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case insensitive
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# ============================================================================
# DEFERRED - Load heavier aliases after shell starts
# ============================================================================
# These use external commands, so defer them
alias l="eza -l --icons --git -a"

# Tree functions with better ergonomics
lt() {
  # List tree: Shows files and directories in tree format
  # Usage: lt [level] [path] [eza-options]
  # If first arg is a number, use as level; otherwise default to 2
  local level=2
  if [[ $1 =~ ^[0-9]+$ ]]; then
    level=$1
    shift
  fi
  eza --tree --level="$level" --long --icons --git --git-ignore "$@"
}

ld() {
  # Directory tree: Shows only directories
  # Usage: ld [level] [path] [eza-options]
  # If first arg is a number, use as level; otherwise default to 2
  local level=2
  if [[ $1 =~ ^[0-9]+$ ]]; then
    level=$1
    shift
  fi
  eza --tree --level="$level" -D --icons --git-ignore "$@"
}

# Additional useful eza shortcuts
la() {
  # List all with details
  eza -la --icons --git --group-directories-first "$@"
}

ll() {
  # List long format
  eza -l --icons --git --group-directories-first "$@"
}

lf() {
  # List files only (no directories)
  eza -lf --icons --git "$@"
}

lt1() { lt 1 "$@"; }  # Quick aliases for common depths
lt2() { lt 2 "$@"; }
lt3() { lt 3 "$@"; }
lt4() { lt 4 "$@"; }

# Yazi wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ============================================================================
# LAZY LOADING - Heavy tools loaded on demand
# ============================================================================

# Lazy load nvm/node (if you use it)
# export NVM_DIR="$HOME/.nvm"
# nvm() {
#   unset -f nvm
#   [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
#   nvm "$@"
# }

# Lazy load gcloud
gcloud() {
  unset -f gcloud
  if [ -f '/Users/vbsec/Development/cloud/google-cloud-sdk/path.zsh.inc' ]; then 
    . '/Users/vbsec/Development/cloud/google-cloud-sdk/path.zsh.inc'
  fi
  if [ -f '/Users/vbsec/Development/cloud/google-cloud-sdk/completion.zsh.inc' ]; then 
    . '/Users/vbsec/Development/cloud/google-cloud-sdk/completion.zsh.inc'
  fi
  gcloud "$@"
}


# Lazy load docker completions
docker() {
  unset -f docker
  fpath=($HOME/.docker/completions $fpath)
  autoload -Uz compinit && compinit -C
  docker "$@"
}

# ============================================================================
# CRITICAL - Prompt (must load synchronously)
# ============================================================================
# Starship prompt - needs to be loaded immediately
eval "$(starship init zsh)"

# ============================================================================
# FAST TOOLS - Load synchronously but they're fast
# ============================================================================
# Zoxide - fast cd (not replacing the builtin)
eval "$(zoxide init zsh)"

# FZF configuration - must set before sourcing fzf
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,cache --preview 'bat --style=numbers --color=always --line-range :501 {}'"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules --preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# FZF tab completion settings
export FZF_COMPLETION_TRIGGER='**'  # Type ** then TAB to trigger
export FZF_COMPLETION_OPTS='--border --info=inline'

# Source FZF - this loads key bindings and completions
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif command -v fzf &>/dev/null; then
  # Fallback to loading fzf completions directly
  source <(fzf --zsh)
fi

# Keep the default trigger for FZF file completion
export FZF_COMPLETION_TRIGGER='**'

# For command completions with FZF, we need fzf-tab plugin
# Install with: git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.config/zsh}/plugins/fzf-tab
if [[ -f ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
  # Configure fzf-tab
  zstyle ':fzf-tab:*' fzf-command fzf
  # Disable preview window
  zstyle ':fzf-tab:*' fzf-flags --no-preview
  # Optional: make it more compact
  zstyle ':fzf-tab:*' fzf-min-height 15
  zstyle ':completion:*:git-checkout:*' sort false
  zstyle ':completion:*:descriptions' format '[%d]'
fi


# Override FZF's default completion generators with faster fd
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# FZF + zsh integration shortcuts
# Use fd for finding files/dirs (faster than find)
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
  --bind="ctrl-d:preview-page-down,ctrl-u:preview-page-up"
  --bind="ctrl-y:execute-silent(echo -n {+} | pbcopy)+abort"
  --bind="ctrl-e:execute(echo {+} | xargs -o nvim)"
'

# Enhanced FZF functions
# Interactive cd with preview
fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf --preview 'tree -C {} | head -100') && cd "$dir"
}

# Interactive file open with preview
fopen() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always {}') && ${EDITOR:-nvim} "$file"
}

# Git branch switcher
fbr() {
  local branches branch
  branches=$(git branch -a --color=never | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf --preview 'git log --oneline --graph --color=always {}' +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Process killer with preview
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --preview 'echo {}' --preview-window down:3:wrap | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Search history with fzf
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# ============================================================================
# ASYNC LOADING - Load in background after shell starts
# ============================================================================
# Start loading heavy stuff in background
{
  # Direnv - can be loaded async
  eval "$(direnv hook zsh)"
  
  # Source other environments
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
  [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
  [ -f "$HOME/.config/west/comp" ] && source "$HOME/.config/west/comp"
} &!

# ============================================================================
# MINIMAL PLUGIN SYSTEM - Replace Oh-My-Zsh
# ============================================================================

# Git aliases (essential ones only)
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull'
alias gp='git push'
alias gst='git status'

# Auto-suggestions (lightweight alternative)
# Only load in interactive shells with ZLE enabled
if [[ $- == *i* ]] && [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# Syntax highlighting (load last)
# Only load in interactive shells with ZLE enabled
if [[ $- == *i* ]] && [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export GRANTED_ENABLE_AUTO_REASSUME=true
export TIMEFMT=$'real\t%E\nuser\t%U\nsys\t%S'
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

# Proto paths (if needed)
export PROTO_HOME="$HOME/.proto"

# Enable profiling: uncomment to see what's slow
# zprof

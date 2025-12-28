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
  # $HOME/.proto/shims
  # $HOME/.proto/bin
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
          fd --type d --max-depth 2 . ~/AndroidStudioProjects 2>/dev/null; } | \
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
          fd --type d --max-depth 2 . ~/AndroidStudioProjects 2>/dev/null; } | \
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
          fd --type d --max-depth 2 . ~/AndroidStudioProjects 2>/dev/null; } | \
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
           fd --type f --max-depth 3 . ~/AndroidStudioProjects 2>/dev/null; } | \
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
alias l="eza -l --icons --git -a --group-directories-first"

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

# Ngrok autocomplete
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

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
# PRODUCTIVITY GOODIES
# ============================================================================

# Quick backup of a file
bak() {
  cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# Extract any archive
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Git worktree switcher with fzf
gw() {
  local worktree
  worktree=$(git worktree list | fzf --preview 'git log --oneline -10 {2}' | awk '{print $1}')
  [[ -n $worktree ]] && cd "$worktree"
}

# Quick notes
note() {
  local notes_dir="$HOME/notes"
  mkdir -p "$notes_dir"
  
  if [[ $# -eq 0 ]]; then
    # No args: list notes with fzf and open selected
    local note=$(ls -1 "$notes_dir" | fzf --preview "cat $notes_dir/{}")
    [[ -n $note ]] && nvim "$notes_dir/$note"
  else
    # With args: create/edit note
    nvim "$notes_dir/$1.md"
  fi
}

# Quick TODO management
todo() {
  local todo_file="$HOME/.todo.md"
  
  case "$1" in
    add|a)
      shift
      echo "- [ ] $*" >> "$todo_file"
      echo "Added: $*"
      ;;
    list|l|"")
      if [[ -f "$todo_file" ]]; then
        cat "$todo_file"
      else
        echo "No todos yet!"
      fi
      ;;
    edit|e)
      nvim "$todo_file"
      ;;
    done|d)
      # Mark items as done interactively
      if [[ -f "$todo_file" ]]; then
        local item=$(grep "^\- \[ \]" "$todo_file" | fzf)
        if [[ -n $item ]]; then
          sed -i "" "s/$(echo "$item" | sed 's/[[\.*^$()+?{|]/\\&/g')/- [x]${item:5}/" "$todo_file"
          echo "Marked as done!"
        fi
      fi
      ;;
    *)
      echo "Usage: todo [add|list|edit|done]"
      ;;
  esac
}

# Quick directory bookmarks
bookmark() {
  local bookmarks_file="$HOME/.bookmarks"
  
  case "$1" in
    add|a)
      echo "$(pwd)|${2:-$(basename $(pwd))}" >> "$bookmarks_file"
      echo "Bookmarked: $(pwd) as '${2:-$(basename $(pwd))}'"
      ;;
    list|l|"")
      if [[ -f "$bookmarks_file" ]]; then
        cat "$bookmarks_file" | column -t -s '|'
      fi
      ;;
    go|g)
      if [[ -f "$bookmarks_file" ]]; then
        local dir=$(cat "$bookmarks_file" | fzf | cut -d'|' -f1)
        [[ -n $dir ]] && cd "$dir"
      fi
      ;;
    *)
      echo "Usage: bookmark [add|list|go]"
      ;;
  esac
}
alias bm=bookmark

# Better git log
glog() {
  git log --graph --pretty=format:'%C(auto)%h%d %s %C(black)%C(bold)%cr %C(auto)%an' "$@"
}

# Quick Python virtual env
venv() {
  if [[ -d .venv ]]; then
    source .venv/bin/activate
  elif [[ -d venv ]]; then
    source venv/bin/activate
  else
    python3 -m venv .venv && source .venv/bin/activate
  fi
}


# Quick ripgrep with preview
rgp() {
  rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:execute(nvim {1} +{2})'
}

# Open .env files with Helix (including gitignored)
henv() {
  local file
  file=$(fd --type f --hidden --no-ignore --exclude .git --exclude node_modules --exclude .venv --exclude venv '^\.env($|\.)' | fzf --preview 'bat --style=numbers --color=always {}')
  [[ -n $file ]] && hx "$file"
}



# ============================================================================
# ASYNC LOADING - Load in background after shell starts
# ============================================================================
# Start loading heavy stuff in background
{
  # Direnv - can be loaded async
  # eval "$(direnv hook zsh)"
  
  # Source other environments
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
  [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
  [ -f "$HOME/.config/west/comp" ] && source "$HOME/.config/west/comp"
} &!

# ============================================================================
# MINIMAL PLUGIN SYSTEM - Replace Oh-My-Zsh
# ============================================================================

# Tmux aliases
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
alias tmuxconf='$EDITOR ~/.tmux.conf'

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
export MISE_ENV=dev

# Proto paths (if needed)
# export PROTO_HOME="$HOME/.proto"
  eval "$(~/.local/bin/mise activate zsh)"

# Enable profiling: uncomment to see what's slow
# zprof

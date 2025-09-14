# echo "start: $(date +%s.%N)"

# export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export LANG=en_US.UTF-8
alias v=nvim
alias l="eza -l --icons --git -a"
lt() {
  local level=${1:-2}
  shift
  eza --tree --level="$level" --long --icons --git --git-ignore "$@"
}

ld() {
  local level=${1:-2}
  shift
  eza --tree --level="$level" -D git --git-ignore "$@"
}
alias py=python
alias cat=bat
alias p=pnpm
export EDITOR=/opt/homebrew/bin/nvim
export ZSH="$HOME/.oh-my-zsh"
alias printpath="echo $PATH | tr ':' '\n'"
alias wip="git add -A && git commit -m 'wip' && git push"
alias lg=lazygit
mkcd() { mkdir -p "$1" && cd "$1"; }

# https://docs.commonfate.io/granted/recipes/automatically_reassume
export GRANTED_ENABLE_AUTO_REASSUME=true
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:plugins:zsh-nvm' mode auto 
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# echo "pre-plugins: $(date +%s.%N)"
plugins=(tmux git zsh-autosuggestions aws zsh-syntax-highlighting command-not-found copypath copyfile fzf gh ripgrep 1password docker)
# export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_DEFAULT_SESSION_NAME="main"
export FZF_BASE=/opt/homebrew/bin/fzf
source $ZSH/oh-my-zsh.sh

export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,cache --preview 'bat --style=numbers --color=always --line-range :501 {}'"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules --preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_DEFAULT_COMMAND="fd"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export TIMEFMT=$'real\t%E\nuser\t%U\nsys\t%S'

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

unset ZSH_AUTOSUGGEST_USE_ASYNC

# vim mode in terminal
bindkey -v

# gcloud cli added these
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vbsec/Development/cloud/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vbsec/Development/cloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vbsec/Development/cloud/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vbsec/Development/cloud/google-cloud-sdk/completion.zsh.inc'; fi

export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/vbsec/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
# expo local builds:
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# Created by `pipx` on 2024-11-23 07:22:06
export PATH="$PATH:/Users/vbsec/.local/bin"
eval "$(register-python-argcomplete pipx)"
fpath+=~/.zfunc
autoload -Uz compinit && compinit

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
# eval "$(gh copilot alias -- zsh)"
eval "$(zoxide init zsh)"
[ -s "/Users/vbsec/.bun/_bun" ] && source "/Users/vbsec/.bun/_bun"
. "$HOME/.cargo/env"

. "$HOME/.config/west/comp"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export PATH="$(brew --prefix)/opt/llvm/bin:$PATH"
export PATH="/Users/vbsec/.deno/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources
export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.11.3.rel1.macos64_1.1.100.202310310803/tools/bin:$PATH"

export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

# proto !! shims need to be first in path !!
export PROTO_HOME="$HOME/.proto";
export PATH="$PROTO_HOME/tools/node/22.14.0/bin:$PROTO_HOME/tools/node/20.19.1/bin:$PATH";
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";
# echo "end: $(date +%s.%N)"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.zsh/completions $HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

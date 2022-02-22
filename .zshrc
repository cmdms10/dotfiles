# zplug
source ~/.zplug/init.zsh
source ~/.zsh_aliases

#----------------------------------------------------
# 環境パス
#----------------------------------------------------
export PATH=$HOME/.nodebrew/current/bin:$PATH

#----------------------------------------------------
# 基本的な設定
#----------------------------------------------------
# 補完の有効化
autoload -Uz compinit
compinit

# zplug を zplug で管理する
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# シェルの設定を色々いい感じにやってくれる。
zplug "yous/vanilli.sh"
# 非同期処理できるようになる
zplug "mafredri/zsh-async"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
# cdのいい感じのやつ
zplug "b4b4r07/enhancd", use:"init.sh"
# peco/peco
# zplug "peco/peco", as:command, from:gh-r
# 高速検索
zplug 'BurntSushi/ripgrep', from:gh-r, as:command, rename-to:"rg"

# インストールされてないプラグインをインストール
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# 矢印キーを使ったより良い履歴検索
if zplug check "zsh-users/zsh-history-substring-search"; then
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
fi

# 履歴関連
export LANG=ja_JP.UTF-8
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
# 重複するコマンドは古い法を削除する
setopt hist_ignore_all_dups 
# 複数タブや複数ウィンドウでのコマンド履歴を共有
setopt share_history
# 補完候補が複数ある時に、一覧表示
setopt auto_list
# 補完時に履歴を自動的に展開
setopt hist_expand
# historyコマンドは履歴に登録しない
setopt hist_no_store

# コマンド移動
# enhancd config
export ENHANCD_COMMAND=ed

# 本体（連携前提のパーツ）
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux, on:"junegunn/fzf-bin"

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 60% --reverse --border'

function fzf-history-widget() {
    local tac=${commands[tac]:-"tail -r"}
    BUFFER=$( ([ -n "$ZSH_NAME" ] && fc -l 1 || history ) | sed 's/ *[0-9]* *//' | eval $tac | awk '!a[$0]++' | fzf +s)
    CURSOR=$#BUFFER
    zle clear-screen
}
zle     -N   fzf-history-widget
bindkey '^F' fzf-history-widget

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

#----------------------------------------------------
# テーマ(ここは好みで。調べた感じpureが人気)
#----------------------------------------------------
zplug "eendroroy/alien"
#
# alien theme
# https://github.com/eendroroy/alien
# 
# テーマ色
export ALIEN_THEME="bnw"
# ホスト名表示
export ALIEN_SECTION_USER_HOST=1
ALIEN_SECTION_USER_FG=3
ALIEN_SECTION_USER_BG=0
# ALIEN_SECTION_USER_BG=0
# 左側のプロンプト
export ALIEN_SECTIONS_LEFT=(
  user
  path
  vcs_branch:async
  newline
  prompt
  ssh
  venv
)
# 右側のプロンプト
export ALIEN_SECTIONS_RIGHT=(
  time
)
# 時間表示
export ALIEN_SECTION_TIME_FORMAT=%Y/%m/%d' '%H:%M # default is %r

export DOCKER_CONTENT_TRUST=1

zplug load

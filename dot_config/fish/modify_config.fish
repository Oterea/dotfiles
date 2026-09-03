{{- /* chezmoi:modify-template */ -}}
if status is-interactive
    # Commands to run in interactive sessions can go here
end
{{- if eq .chezmoi.os "darwin" }}

set -x PATH /opt/homebrew/bin $PATH
{{- end }}
{{- if eq .chezmoi.os "linux" }}

set -x PATH $HOME/.x-cmd.root/local/data/pkg/sphere/X/l/j/h/bin $PATH
{{- end }}

set -x PATH $HOME/.local/bin $PATH

alias ll='ls -alF'
alias la='ls -A'
alias ls='ls -CF'

# <<<<==starship==>>>>
if command -v starship > /dev/null
    printf "starship init fish\n"
    starship init fish | source
else
    printf "starship is not installed\n"
end
# <<<<==zoxide==>>>>
if command -v zoxide > /dev/null
    printf "zoxide init fish\n"
    zoxide init --cmd cd fish | source
else
    printf "zoxide is not installed\n"
end
# <<<<==fzf==>>>>
if command -v fzf > /dev/null
    printf "fzf init fish\n"
    fzf --fish | source
else
    printf "fzf is not installed\n"
end

{{/*
  以下内容不由本仓库管理，从目标文件里原样保留。
  conda init 会往 config.fish 追加自己的块，那是机器特定的、由 conda 自己维护的，
  不该进仓库；但 apply 也不能把它冲掉。modify_ 让两者共存。
  以后有别的工具往这里塞东西，照这个模式再加一段即可。
*/ -}}
{{- $conda := regexFind "(?s)# >>> conda initialize >>>.*?# <<< conda initialize <<<" .chezmoi.stdin -}}
{{- with $conda }}{{ . }}
{{ end -}}

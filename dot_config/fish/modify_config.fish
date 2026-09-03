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

# 以下内容不由 chezmoi 管理：各工具（conda init 之类）自行追加，apply 时原样保留。
{{ $marker := "# ==== chezmoi 管理到此为止 ====" -}}
{{ $marker }}
{{- $rest := splitList $marker .chezmoi.stdin -}}
{{- if gt (len $rest) 1 }}{{ index $rest 1 }}{{ end -}}

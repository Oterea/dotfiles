if status is-interactive
    # Commands to run in interactive sessions can go here
end
function chezmoiin
    cd ~/.local/share/chezmoi
end

set -x EDITOR "/usr/local/bin/zed --wait"
set -x PATH /opt/homebrew/bin /usr/local/bin $PATH
starship init fish | source


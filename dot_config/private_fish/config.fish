if status is-interactive
    # Commands to run in interactive sessions can go here
end


if status --is-login
    set -gx PATH /opt/homebrew/bin $PATH
end

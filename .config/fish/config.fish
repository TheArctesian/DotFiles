if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_greeting
	rxfetch
	feh --bg-fill --randomize ~/Pictures/wallpaper/*
end
alias ls "lsd"
alias la "lsd -la"
alias lla "lsd -la"
alias lt  "lsd --tree"
alias vim "nvim"
alias cls "clear"
alias p "ping -c 3 gentoo.org"
alias py "python3"
alias clok "tty-clock -c -C 4 -S"
alias pull "git pull"
alias neo "neovide"
alias skl "cd Scripts/School"
alias per "cd Scripts/Personal"
alias pro "cd Scripts/Project"

fish_add_path /home/arctesian/.spicetify


# Greeting 
function fish_greeting
	pfetch
	feh --bg-fill --randomize ~/Pictures/wallpaper/*
end

alias vim "nvim"
alias clok "tty-clock -c -C 4 -S"

# doom

alias doom "~/.emacs.d/bin/doom"

# shortcuts
alias p "ping -c 3 gentoo.org"
alias py "python3"
alias cls "clear"

# alias cat "bat"

# Git
alias pull "git pull"

# Dir short cuts
alias skl "cd ~/Scripts/School"
alias per "cd ~/Scripts/Personal"
alias wrk "cd ~/Scripts/Work"
alias conf "cd ~/.config"
alias pro "cd ~/Scripts/Project"
alias down "cd ~/Downloads"
alias sec "cd ~/Documents/Second\ Brain/"
alias uni "cd ~/Documents/Second\ Brain/Uni/"

# ls 
alias ls "lsd"
fish_add_path /home/arctesian/.spicetify

alias server="browser-sync start -s -f . --no-notify --host $LOCAL_UP --port 9000"

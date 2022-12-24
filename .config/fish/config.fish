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

# Git
alias pull "git pull"
alias neo "neovide"

# Dir short cuts
alias skl "cd ~/Scripts/School"
alias per "cd ~/Scripts/Personal"
alias conf "cd ~/.config"
alias pro "cd ~/Scripts/Project"
alias down "cd ~/Downloads"

# ls 
alias ls "exa -l"
fish_add_path /home/arctesian/.spicetify

# server
export LOCAL_IP=`ipconfig getifaddr en0`
alias serve="browser-sync start -s -f . --no-notify --host $LOCAL_IP --port 9000"
# npm install -g browser-sync first



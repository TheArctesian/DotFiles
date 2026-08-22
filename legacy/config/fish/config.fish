# ==============================
# Fish Configuration
# ==============================

# Paths
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.spicetify
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/development/flutter/bin
# Initialize tools
zoxide init fish | source

# ==============================
# Greeting & Appearance
# ==============================
function fish_greeting
    pfetch
end

# ==============================
# Random wallpaper on new session
# ==============================
if status is-interactive
    set -l wp_dir "$HOME/Pictures/wallpapers/framework13"
    set -l wallpapers $wp_dir/*.png
    if test (count $wallpapers) -gt 0
        set -l pick $wallpapers[(random 1 (count $wallpapers))]
        set -l cfg "$HOME/.config/cosmic/com.system76.CosmicBackground/v1/all"
        printf '(\n    output: "all",\n    source: Path("%s"),\n    filter_by_theme: true,\n    rotation_frequency: 300,\n    filter_method: Lanczos,\n    scaling_mode: Zoom,\n    sampling_method: Alphanumeric,\n)\n' "$pick" >"$cfg"
    end
end

# ==============================
# Aliases - General
# ==============================
alias vim="nvim"
alias cls="clear"
alias p="ping -c 3 gentoo.org"
alias py="python3"
alias server="browser-sync start -s -f . --no-notify --host $LOCAL_UP --port 9000"
alias clok="tty-clock -c -C 4 -S"
alias copy="xclip -sel c <"
alias zcc="zellij --layout ~/.config/zellij/claude.kdl"
alias zco="zellij --layout ~/.config/zellij/codex.kdl"

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Paste clipboard content to a file (replacing entire file)
function past
    if test (count $argv) -eq 0
        echo "Usage: past [filename]"
        return 1
    end

    # Create backup of the original file if it exists
    set -l filename $argv[1]
    if test -f $filename
        set -l backup $filename.bak
        cp $filename $backup
        echo "Backup saved as $backup"
    end

    # Get clipboard content
    set -l clipboard_content (xclip -sel c -o)

    # Write to file
    echo $clipboard_content >$filename

    # Ensure file is properly written by syncing filesystem
    sync

    # Display the file content with bat
    echo "Content pasted to $filename:"
end

# Function to copy directory contents to clipboard
function copydir
    if test (count $argv) -eq 0
        echo "Usage: copydir [directory]"
        return 1
    end

    set -l target_dir $argv[1]

    if not test -d $target_dir
        echo "Error: '$target_dir' is not a directory"
        return 1
    end

    # Create a temporary file
    set -l temp_file (mktemp)

    # Find all files recursively and process them
    fd --type f . $target_dir | sort | while read -l file
        # Get relative path to make header cleaner
        set -l rel_path (realpath --relative-to=(pwd) $file)

        # Add file header with name and extension
        echo "# $rel_path" >>$temp_file

        # Add file content
        cat $file >>$temp_file

        # Add newline separator
        echo "" >>$temp_file
    end

    # Copy to clipboard
    cat $temp_file | xclip -sel c

    # Count files processed
    set -l file_count (fd --type f . $target_dir | wc -l)
    echo "Copied contents of $file_count files from '$target_dir' to clipboard"

    # Clean up
    rm $temp_file
end

# ==============================
# Aliases - Improved CLI Tools
# ==============================
alias ll="eza -alF"
alias la="eza -A"
alias ls="eza --icons --grid --group-directories-first"
alias cat="batcat -p"
# alias curl="xh"
alias tmux="zellij"
# alias du="dust"
# alias find="fd"
# alias cowsay="neo-cowsay"
# alias cp="xcp"

# Grep with color (from bashrc)
alias grep="grep --color=auto"

# ==============================
# Aliases - Directory Shortcuts
# ==============================
alias down="cd $HOME/Downloads"
alias conf="cd $HOME/.config"

# Scripts
alias skl="cd $HOME/Scripts/School"
alias per="cd $HOME/Scripts/Personal"
alias wrk="cd $HOME/Scripts/Work"
alias pro="cd $HOME/Scripts/Project"
alias org="cd $HOME/Scripts/Organising"

# ==============================
# Aliases - Git
# ==============================
alias pull="git pull"
alias pus="git push"

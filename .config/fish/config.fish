# ==============================
# Fish Configuration
# ==============================

# Paths
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.spicetify
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/development/flutter/bin

if type -q brew
    set -l rustup_prefix (brew --prefix rustup 2>/dev/null)
    and fish_add_path "$rustup_prefix/bin"
end

# Initialize tools
if type -q zoxide
    zoxide init fish | source
end

# ==============================
# Greeting & Appearance
# ==============================
function fish_greeting
    if type -q pfetch
        pfetch
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
alias copy="pbcopy <"
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
    set -l filename "$argv[1]"
    if test -f "$filename"
        set -l backup "$filename.bak"
        cp "$filename" "$backup"
        echo "Backup saved as $backup"
    end

    pbpaste >"$filename"

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
    set -l base_dir (pwd -P)

    if not test -d "$target_dir"
        echo "Error: '$target_dir' is not a directory"
        return 1
    end

    # Create a temporary file
    set -l temp_file (mktemp)

    # Find all files recursively and process them
    fd --type f --exclude node_modules --exclude .git . $target_dir | sort | while read -l file
        # Get relative path to make header cleaner
        set -l absolute_path (path resolve $file)
        set -l rel_path (string replace -- "$base_dir/" "" $absolute_path)

        # Add file header with name and extension
        echo "# $rel_path" >>$temp_file

        # Add file content
        command cat "$file" >>"$temp_file"

        # Add newline separator
        echo "" >>"$temp_file"
    end

    # Copy to clipboard
    pbcopy <"$temp_file"

    # Count files processed
    set -l file_count (fd --type f --exclude node_modules --exclude .git . $target_dir | wc -l)
    echo "Copied contents of $file_count files from '$target_dir' to clipboard"

    # Clean up
    rm "$temp_file"
end

# ==============================
# Aliases - Improved CLI Tools
# ==============================
alias ll="eza -alF"
alias la="eza -A"
alias ls="eza --icons --grid --group-directories-first"
alias cat="bat -p"
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

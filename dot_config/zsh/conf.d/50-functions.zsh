# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Package Management ---
pacs() {
    pacman -Ss "$@"
}

paci() {
    sudo pacman -S "$@"
}

pacr() {
    sudo pacman -Rns "$@"
}

# Search installed packages with fzf
pakages() {
    pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)' "$@"
}

# Show recently installed packages
pkglast() {
    local n="${1:-20}"
    expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n "$n"
}

# --- File Operations ---
# Move directory to trash
rmtree() {
    trash "$@"
}

# --- Python/UV ---
# Install packages from requirements file using uv
pipr() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: pipr <requirements-file>"
        return 1
    fi
    
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue
        
        echo "Installing $package ..."
        uv pip install "$package"
    done < "$1"
}

# --- Unified RC Navigation ---
# Quickly open config files
rc() {
    local oldpwd="$PWD"

    if [[ $# -eq 0 ]]; then
        cd "$HOME/.config" || return
        nvim .
        cd "$oldpwd"
        return
    fi

    local target="${1:l}"  # zsh lowercase
    local dir=""
    local file=""

    case "$target" in
        kitty)
            dir="$HOME/.config/kitty"
            file="kitty.conf"
            ;;
        hypr|hyprland)
            dir="$HOME/.config/hypr"
            file="hyprland.conf"
            ;;
        fish)
            dir="$HOME/.config/fish"
            file="config.fish"
            ;;
        zsh)
            dir="$HOME/.config/zsh"
            file="config.d"
            ;;
        alias)
            dir="$HOME/.config/zsh"
            file="conf.d/40-alias.zsh"
            ;;
        nvim|nvimrc)
            dir="$HOME/.config/nvim"
            file="init.lua"
            ;;
        bspwm)
            dir="$HOME/.config/bspwm"
            file="bspwmrc"
            ;;
        sxhkd)
            dir="$HOME/.config/sxhkd"
            file="sxhkdrc"
            ;;
        polybar)
            dir="$HOME/.config/polybar"
            file="modules.ini"
            ;;
        picom)
            dir="$HOME/.config/picom"
            file="picom.conf"
            ;;
        xresources)
            nvim "$HOME/.Xresources"
            return
            ;;
        *)
            if [[ -d "$HOME/.config/$target" ]]; then
                dir="$HOME/.config/$target"
            else
                echo "No config found for: $target"
                return 1
            fi
            ;;
    esac

    if [[ -n "$dir" ]]; then
        cd "$dir" || return
        if [[ -n "$file" && -f "$file" ]]; then
            nvim "$file"
        else
            nvim .
        fi
        cd "$oldpwd"
    fi
}

# Compatibility Helpers
c() {
    rc "$@"
}

ASPTRC() {
    rc "$@"
}

# --- Mount NTFS Drive ---
mount-drive-hhd() {
    sudo mkdir -p /mnt/mydrive
    sudo mount -t ntfs-3g /dev/sda1 /mnt/mydrive
}



# Kill port based on port number
killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port>"
    return 1
  fi

  local port="$1"
  local -a pids

  pids=($(lsof -t -i :"$port"))

  if (( ${#pids[@]} == 0 )); then
    echo "No process found on port $port"
    return 0
  fi

  echo "Killing process(es) on port $port: ${pids[*]}"
  kill -9 "${pids[@]}"
}


# Search for a string in files and preview matches with fzf
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}


gmail-mail-last-3() {
    local ids width
    width=$(tput cols 2>/dev/null || echo 100)
    ids=($(gws gmail users messages list --params '{"userId":"me","maxResults":3}' 2>/dev/null | jq -r '.messages[].id'))

    if [[ ${#ids[@]} -eq 0 ]]; then
        echo "No messages found or auth error."
        return 1
    fi

    printf "%s\n" "${ids[@]}" |
    xargs -P 5 -I {} gws gmail users messages get --params '{"userId":"me","id":"{}"}' 2>/dev/null |
    jq -r '
        def decode:
            gsub("&#39;"; "'\''")
            | gsub("&quot;"; "\"")
            | gsub("&amp;"; "&")
            | gsub("&lt;"; "<")
            | gsub("&gt;"; ">");

        def header($name):
            first(.payload.headers[]? | select(.name == $name) | .value);

        def recipient:
            (header("Delivered-To") // header("X-Original-To") // header("To") // "N/A") | decode;

        def email_only:
            recipient
            | if test("<[^>]+>") then
                capture("<(?<mail>[^>]+)>").mail
              else
                .
              end;

        "###MAIL###",
        ((header("Subject") // "N/A") | decode),
        (email_only // "N/A"),
        ((.snippet // "N/A") | decode)
    ' | awk -v width="$width" '
        function wrap(text, indent, first_indent,   cmd, line) {
            gsub(/\r/, "", text)
            cmd = "fold -s -w " (width - indent - 2)
            print text | cmd
            close(cmd)
        }

        BEGIN { state = 0 }

        /^###MAIL###$/ {
            if (state != 0) {
                print "\033[32m------------------------------------------------------------\033[0m"
            }
            state = 1
            next
        }

        state == 1 {
            subject = $0
            printf "\033[1;34mSubject :\033[0m %s\n", subject
            state = 2
            next
        }

        state == 2 {
            to = $0
            printf "\033[1;35mTo      :\033[0m %s\n", to
            state = 3
            next
        }

        state == 3 {
            snippet = $0
            cmd = "fold -s -w " (width - 11)
            print snippet | cmd
            close(cmd)
            state = 4
            next
        }

        state == 4 {
            # unused
        }
    ' | awk '
        BEGIN { snippet_mode = 0 }
        /^Subject :/ || /^\033\[1;34mSubject :\033\[0m/ { snippet_mode = 0; print; next }
        /^To      :/ || /^\033\[1;35mTo      :\033\[0m/ { snippet_mode = 0; print; next }
        /^\033\[32m/ { snippet_mode = 0; print; next }

        {
            if (snippet_mode == 0) {
                printf "\033[90;1mSnippet :\033[0m %s\n", $0
                snippet_mode = 1
            } else {
                printf "%10s %s\n", "", $0
            }
        }
    '
}
gmail-mail-last-4() {
    local ids
    ids=($(gws gmail users messages list --params '{"userId": "me", "maxResults": 3}' 2>/dev/null | jq -r '.messages[].id'))

    printf "%s\n" "${ids[@]}" | xargs -P 3 -I {} gws gmail users messages get --params '{"userId": "me", "id": "{}"}' 2>/dev/null | jq -r '
        def decode_b64:
            gsub("-"; "+") | gsub("_"; "/") | @base64d;

        def get_body:
            if .payload.parts then
                (.payload.parts[]
                 | select(.mimeType=="text/html")
                 | .body.data // empty)
            else
                .payload.body.data
            end;

        "Subject: " + (.payload.headers[] | select(.name=="Subject").value) +
        "\n---HTML---\n" +
        (get_body | decode_b64) +
        "\n==========\n"
    ' | w3m -T text/html | vim
}

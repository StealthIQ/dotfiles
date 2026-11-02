# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Package Management ---
function pacs; pacman -Ss $argv; end
function paci; sudo pacman -S $argv; end
function pacr; sudo pacman -Rns $argv; end

function pakages --description 'Search installed packages with fzf'
    pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)' $argv
end

function pkglast --description 'Show recently installed packages'
    expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n $argv
end

# --- File Operations ---
function rmtree --description 'Move directory to trash'
    trash $argv
end

function mount-drive-hhd --description 'Mount NTFS drive dynamically to /mnt/mydrive'
    set -l target $argv[1]
    
    if test -z "$target"
        set -l root_disk (lsblk -no PKNAME (findmnt -n -o SOURCE / 2>/dev/null) 2>/dev/null)
        set target (lsblk -lno NAME,FSTYPE,PKNAME | awk -v root="$root_disk" '$3!=root && $2=="ntfs" {print "/dev/"$1; exit}')
    else if not string match -q "/*" "$target"
        set target "/dev/$target"
    end

    if test -z "$target" -o ! -b "$target"
        echo "[x] Error: No NTFS partition found."
        echo "[*] Available partitions:"
        lsblk -pno NAME,SIZE,FSTYPE,LABEL
        return 1
    end

    set -l mount_point "/mnt/mydrive"
    sudo mkdir -p $mount_point
    echo "[*] Target partition: $target"

    if command -v ntfsfix >/dev/null
        echo "[*] Checking NTFS volume health..."
        sudo ntfsfix -b -d $target 2>/dev/null || true
    end

    echo "[*] Mounting $target to $mount_point..."
    if sudo mount -t ntfs-3g -o remove_hiberfile,uid=(id -u),gid=(id -g),rw,noatime $target $mount_point 2>/dev/null
        echo "[+] Successfully mounted $target at $mount_point (via ntfs-3g)"
    else if sudo mount -t ntfs3 -o rw,noatime,uid=(id -u),gid=(id -g) $target $mount_point 2>/dev/null
        echo "[+] Successfully mounted $target at $mount_point (via ntfs3)"
    else
        echo "[!] Direct mount failed. Attempting udisksctl fallback..."
        udisksctl mount -b $target
    end
end




# --- Python/UV ---
function pipr --description 'Install packages from requirements file using uv'
    if test (count $argv) -lt 1
        echo "Usage: pipr <requirements-file>"
        return 1
    end
    for package in (cat $argv[1])
        if test -n "$package"
            echo "Installing $package ..."
            uv pip install "$package"
        end
    end
end

function rc --description 'Open config (recent file → default file → directory)'
    set -l oldpwd $PWD

    if test (count $argv) -eq 0
        cd ~/.config; or return
        nvim .
        cd $oldpwd
        return
    end

    set -l target (string lower -- $argv[1])
    set -l dir ""
    set -l file ""

    switch $target
        case kitty
            set dir ~/.config/kitty
            set file kitty.conf
        case hypr hyprland
            set dir ~/.config/hypr
            set file hyprland.conf
        case fish
            set dir ~/.config/fish
            set file conf.d/40-alias.fish
        case nvim nvimrc
            set dir ~/.config/nvim
            set file init.lua
        case bspwm
            set dir ~/.config/bspwm
            set file bspwmrc
        case sxhkd
            set dir ~/.config/sxhkd
            set file sxhkdrc
        case polybar
            set dir ~/.config/polybar
            set file modules.ini
        case picom
            set dir ~/.config/picom
            set file picom.conf
        case xresources
            nvim ~/.Xresources
            return
        case '*'
            if test -d ~/.config/$target
                set dir ~/.config/$target
            else
                echo "No config found for: $target"
                return 1
            end
    end

    if test -n "$dir"
        cd $dir; or return

        if test -n "$file"; and test -f "$file"
            # Explicit default defined, always use it
            nvim "$file"
        else
            # No preset, open most recently modified file
            set -l recent (LC_ALL=C find . -type f \
                -not -path '*/.git/*' \
                -not -name 'fish_variables*' \
                -printf '%T@ %p\n' 2>/dev/null \
                | sort -rn \
                | head -n1 \
                | cut -d' ' -f2-)

            if test -n "$recent"; and test -f "$recent"
                nvim "$recent"
            else
                nvim .
            end
        end

        cd $oldpwd
    end
end


# Compatibility Helpers
function c; rc $argv; end
function ASPTRC; rc $argv; end


# Kill port based on port number
function killport --description "Kill process based on port number"
    if test (count $argv) -eq 0
        echo "Usage: killport <port>"
        return 1
    end

    set -l port $argv[1]
    set -l pids (lsof -t -i :$port 2>/dev/null)

    if test (count $pids) -eq 0
        echo "No process found on port $port"
        return 0
    end

    echo "Killing process(es) on port $port: $pids"
    kill -9 $pids
end


function fif --description "Search for a string in files and preview matches with fzf"
    if test (count $argv) -eq 0
        echo "Need a string to search for!"
        return 1
    end

    set -l query $argv[1]

    rg --files-with-matches --no-messages "$query" |
        fzf --preview "highlight -O ansi -l {} 2>/dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$query' || rg --ignore-case --pretty --context 10 '$query' {}"
end


function gmail-mail-last-3
    set -l width (tput cols 2>/dev/null; or echo 100)
    set -l ids (gws gmail users messages list --params '{"userId":"me","maxResults":3}' 2>/dev/null | jq -r '.messages[]?.id')

    if test (count $ids) -eq 0
        echo "No messages found or auth error."
        return 1
    end

    printf "%s\n" $ids |
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
        ' |
        awk -v width="$width" '
            BEGIN { state = 0 }

            /^###MAIL###$/ {
                if (state != 0) {
                    print "\033[32m------------------------------------------------------------\033[0m"
                }
                state = 1
                next
            }

            state == 1 {
                printf "\033[1;34mSubject :\033[0m %s\n", $0
                state = 2
                next
            }

            state == 2 {
                printf "\033[1;35mTo      :\033[0m %s\n", $0
                state = 3
                next
            }

            state == 3 {
                cmd = "fold -s -w " (width - 11)
                print $0 | cmd
                close(cmd)
                state = 4
                next
            }
        ' |
        awk '
            BEGIN { snippet_mode = 0 }

            /^Subject :/ || /^\033\[1;34mSubject :\033\[0m/ {
                snippet_mode = 0
                print
                next
            }

            /^To      :/ || /^\033\[1;35mTo      :\033\[0m/ {
                snippet_mode = 0
                print
                next
            }

            /^\033\[32m/ {
                snippet_mode = 0
                print
                next
            }

            {
                if (snippet_mode == 0) {
                    printf "\033[90;1mSnippet :\033[0m %s\n", $0
                    snippet_mode = 1
                } else {
                    printf "%10s %s\n", "", $0
                }
            }
        '
end


function gmail-mail-last-4
    set -l ids (gws gmail users messages list --params '{"userId":"me","maxResults":3}' 2>/dev/null | jq -r '.messages[]?.id')

    if test (count $ids) -eq 0
        echo "No messages found or auth error."
        return 1
    end

    printf "%s\n" $ids |
        xargs -P 3 -I {} gws gmail users messages get --params '{"userId":"me","id":"{}"}' 2>/dev/null |
        jq -r '
            def decode_b64:
                gsub("-"; "+") | gsub("_"; "/") | @base64d;

            def get_body:
                if .payload.parts then
                    (.payload.parts[]
                        | select(.mimeType == "text/html")
                        | .body.data // empty)
                else
                    .payload.body.data
                end;

            "Subject: " + ((.payload.headers[]? | select(.name == "Subject").value) // "N/A") +
            "\n---HTML---\n" +
            ((get_body // "") | decode_b64) +
            "\n==========\n"
        ' |
        w3m -T text/html |
        vim -
end



function use_brave
    set app brave-browser.desktop

    xdg-settings set default-web-browser $app
    xdg-mime default $app x-scheme-handler/http
    xdg-mime default $app x-scheme-handler/https
    xdg-mime default $app text/html

    echo "Default browser set to Brave"
end

function use_browseros
    set app browseros.desktop

    xdg-settings set default-web-browser $app
    xdg-mime default $app x-scheme-handler/http
    xdg-mime default $app x-scheme-handler/https
    xdg-mime default $app text/html

    echo "Default browser set to BrowserOS"
end

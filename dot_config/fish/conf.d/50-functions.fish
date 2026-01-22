function __sudo_last
    set -l cmd (history --max=1)
    commandline -r "sudo $cmd"
    commandline -f execute
end

bind \cs '__sudo_last'

function c
    if test (count $argv) -eq 0
        cd ~/.config; or return
        ls
        return
    end

    set -l target (string lower -- $argv[1])
    set -l dir ""
    set -l file ""

    switch $target
        case opencode
            set dir ~/.config/opencode/
            set file oh-my-opencode.json
        case kitty
            set dir ~/.config/kitty
            set file kitty.conf
        case hypr hyprland
            set dir ~/.config/hypr
            set file hyprland.conf
        case fish
            set dir ~/.config/fish
            set file config.fish
        case alias
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
            set file config.ini
        case picom
            set dir ~/.config/picom
            set file picom.conf
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
        if test -n "$file" -a -f "$file"
            nvim $file
        else
            ls
        end
    end
end

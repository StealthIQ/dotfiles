# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# External Tools Initialization
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Starship Prompt ---
if type -q starship
    starship init fish | source
end

# --- Zoxide (Smarter cd) ---
if type -q zoxide
    zoxide init fish | source
end

# --- Kitty / QuickShell sequences ---
set -l sequences_file ~/.local/state/quickshell/user/generated/terminal/sequences.txt
if test -f $sequences_file
    cat $sequences_file
end

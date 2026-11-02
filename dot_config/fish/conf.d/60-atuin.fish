# Shared shell history (Ctrl+R). Added by ~/optimize.sh
if status is-interactive; and type -q atuin
    atuin init fish --disable-up-arrow | source
end

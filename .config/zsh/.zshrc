# Load Powerlevel10k theme configuration
source ~/.config/zsh/p10k.zsh
source ~/.config/zsh/.p10k.zsh

# Load environment variables
source ~/.config/zsh/env.zsh

# Load Base 
source ~/.config/zsh/base.zsh

# Load aliases
source ~/.config/zsh/aliases.zsh

# Load git Alias
source ~/.config/zsh/git.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/stealthiq/Downloads/text-generation-webui-main/installer_files/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/stealthiq/Downloads/text-generation-webui-main/installer_files/conda/etc/profile.d/conda.sh" ]; then
        . "/home/stealthiq/Downloads/text-generation-webui-main/installer_files/conda/etc/profile.d/conda.sh"
    else
        export PATH="/home/stealthiq/Downloads/text-generation-webui-main/installer_files/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


. "$HOME/.cargo/env"

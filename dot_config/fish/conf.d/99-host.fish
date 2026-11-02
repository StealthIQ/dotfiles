# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Host-specific configurations
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This file loads host-specific environment variables and configurations
# from the 'host/' subdirectory based on the current environment.

for f in $__fish_config_dir/conf.d/host/*.fish
    if test -f $f
        source $f
    end
end

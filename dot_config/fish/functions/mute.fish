function mute --description 'Mute the default audio sink'
    if not wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
        echo 'mute: wpctl failed — is there a default audio sink?' >&2
        return 1
    end
    wpctl get-volume @DEFAULT_AUDIO_SINK@
end

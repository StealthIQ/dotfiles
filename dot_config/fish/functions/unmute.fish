function unmute --description 'Unmute the default audio sink'
    if not wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        echo 'unmute: wpctl failed — is there a default audio sink?' >&2
        return 1
    end
    wpctl get-volume @DEFAULT_AUDIO_SINK@
end

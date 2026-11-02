function oracle-tf-auto --description 'Toggle the OCI Terraform auto-provisioner service'
    set -l unit oci-auto.service

    if systemctl --user is-active --quiet $unit
        systemctl --user stop $unit
        if systemctl --user is-active --quiet $unit
            echo "oracle-tf-auto: failed to stop" >&2
            return 1
        end
        echo "oracle-tf-auto: stopped"
        return 0
    end

    systemctl --user start $unit
    sleep 1
    if systemctl --user is-active --quiet $unit
        echo "oracle-tf-auto: started"
        return 0
    end

    echo "oracle-tf-auto: failed to start (journalctl --user -u oci-auto)" >&2
    return 1
end

#!/bin/bash

# ----------- Constants -----------
DEFAULT_SWAP="/swapfile"
BASHRC="$HOME/.bashrc"

# ----------- Utility Functions -----------

# Automatically mount unmounted USB devices
auto_mount_usb_devices() {
    while IFS= read -r dev; do
        mountpoint=$(lsblk -no MOUNTPOINT "$dev")
        if [ -z "$mountpoint" ]; then
            label=$(lsblk -no LABEL "$dev")
            [[ -z "$label" ]] && label="USB_$(basename "$dev")"
            mount_dir="/run/media/$USER/$label"
            sudo mkdir -p "$mount_dir"
            sudo mount "$dev" "$mount_dir" 2>/dev/null
        fi
    done < <(lsblk -lpno NAME,RM | awk '$2 == 1 {print $1}')
}

# Pretty print a table of available USB-like mount points
list_usb_devices() {
    echo -e "\n📦 Detected External Storage Devices:\n"
    printf "%-3s | %-35s | %-10s | %-10s | %-10s | %-15s\n" "No." "Mount Point" "Total(GB)" "Used(GB)" "Free(GB)" "Safe Swap Limit(GB)"
    echo "-----------------------------------------------------------------------------------------------"

    declare -gA usb_list
    i=1

    while IFS= read -r line; do
        dev=$(echo "$line" | awk '{print $1}')
        mountpoint=$(echo "$line" | awk '{print $2}')

        if [[ "$mountpoint" =~ ^/boot|^/$|^/home|^/var ]]; then
            continue
        fi

        if udevadm info --query=property --name="$dev" 2>/dev/null | grep -q 'ID_BUS=usb'; then
            :
        else
            if [[ "$mountpoint" != /run/media/* && "$mountpoint" != /media/* && "$mountpoint" != /mnt/* ]]; then
                continue
            fi
        fi

        total=$(df -BG --output=size "$mountpoint" | tail -1 | tr -dc '0-9')
        used=$(df -BG --output=used "$mountpoint" | tail -1 | tr -dc '0-9')
        free=$(df -BG --output=avail "$mountpoint" | tail -1 | tr -dc '0-9')
        safe=$(awk -v f="$free" 'BEGIN { printf "%.1f", (f * 0.25 < 8 ? f * 0.25 : 8) }')

        printf "%-3s | %-35s | %-10s | %-10s | %-10s | %-15s\n" "$i" "$mountpoint" "$total" "$used" "$free" "$safe"
        usb_list["$i"]="$mountpoint"
        ((i++))
    done < <(lsblk -lpno NAME,MOUNTPOINT | grep -v "loop" | awk '$2!=""')

    if [[ $i -eq 1 ]]; then
        echo "❌ No mounted external devices found."
    fi
}

get_swap_size() {
    local suggested_max=$1
    local swap_size

    read -p "Enter swap size in GB (suggested max is $suggested_max GB): " swap_size

    # Must be a number
    if ! [[ "$swap_size" =~ ^[0-9]+$ ]]; then
        echo "❌ Invalid input. Please enter a number." >&2
        return 1
    fi

    if (( swap_size > suggested_max )); then
        echo -e "⚠️  Warning: You've chosen $swap_size GB swap, which exceeds the suggested safe max of $suggested_max GB." >&2
        echo -e "💡 This may reduce USB lifespan or impact performance, but it's allowed. Proceeding..." >&2
    fi

    # Only return the number itself
    echo "$swap_size"
    return 0
}

create_swap_file() {
    local target_file="$1"
    local size_gb="$2"
    local size_mb=$((size_gb * 1024))

    echo "Creating $size_gb GB swap file at $target_file..."
    sudo dd if=/dev/zero of="$target_file" bs=1M count="$size_mb" status=progress
    sudo chmod 600 "$target_file"
    sudo mkswap "$target_file"
    sudo swapon "$target_file"
    echo "✅ Swap created and enabled."
    sudo sysctl vm.swappiness=10
    swapon --show
    free -h
}

delete_swap_file() {
    local target_file="$1"
    if [ ! -f "$target_file" ]; then
        echo "No swap file found at $target_file."
        return
    fi
    sudo swapoff "$target_file"
    sudo rm -f "$target_file"
    echo "🧹 Swap file deleted."
    swapon --show
}

create_usb_swap() {
    auto_mount_usb_devices
    list_usb_devices
    echo -e "\nChoose a USB device:"
    read -p "Enter device number: " usb_choice
    selected_mount=${usb_list[$usb_choice]}

    if [ -z "$selected_mount" ]; then
        echo "❌ Invalid selection."
        return
    fi

    total_free=$(df -BG --output=avail "$selected_mount" | tail -1 | tr -dc '0-9')
    suggested=$(awk -v f="$total_free" 'BEGIN { printf "%.0f", (f * 0.25 < 8 ? f * 0.25 : 8) }')
    swap_size=$(get_swap_size "$suggested") || {
        echo "❌ Invalid swap size input. Aborting."
        return
    }

    local swap_file="$selected_mount/swapfile"
    create_swap_file "$swap_file" "$swap_size"
}

setup_ollama_models_dir() {
    auto_mount_usb_devices
    list_usb_devices
    echo -e "\nChoose a USB device to use for storing Ollama models:"
    read -p "Enter device number: " usb_choice
    selected_mount=${usb_list[$usb_choice]}
    if [ -z "$selected_mount" ]; then
        echo "❌ Invalid selection."
        return
    fi

    model_path="$selected_mount/ollama_models"
    mkdir -p "$model_path"

    export OLLAMA_MODELS="$model_path"
    if ! grep -q "OLLAMA_MODELS=" "$BASHRC"; then
        echo "export OLLAMA_MODELS=\"$model_path\"" >> "$BASHRC"
    fi

    echo "✅ OLLAMA_MODELS path set to: $model_path"
    echo "ℹ️  Restart terminal or run: source ~/.bashrc"
}

install_zram_swap() {
    echo "🔍 Checking for zram-generator..."
    if ! command -v zramctl &>/dev/null || [ ! -f /etc/systemd/zram-generator.conf ]; then
        echo "📦 Installing zram-generator..."
        sudo pacman -Sy --noconfirm zram-generator
    fi

    echo "🧠 Configuring zram-based swap..."
    sudo tee /etc/systemd/zram-generator.conf > /dev/null <<EOF
[zram0]
zram-size = min(ram, 4096MiB)
compression-algorithm = zstd
EOF

    echo "🔁 Reloading systemd and enabling zram swap..."
    sudo systemctl daemon-reexec
    sudo systemctl restart systemd-zram-setup@zram0.service

    echo "✅ zram swap is active:"
    swapon --show
    free -h
}

delete_zram_swap() {
    echo "♻️  Disabling and removing zram swap config..."
    sudo swapoff /dev/zram0 2>/dev/null
    sudo rm -f /etc/systemd/zram-generator.conf
    sudo systemctl daemon-reexec
    echo "✅ zram swap removed."
}

# ----------- Menu -----------

declare -A usb_list

while true; do
    echo -e "\n💾 Ollama Swap + Model Manager"
    echo "1. Create normal swap on root disk"
    echo "2. Create swap on USB/external storage"
    echo "3. Delete normal swap"
    echo "4. Delete USB swap"
    echo "5. Configure Ollama to use USB for model storage"
    echo "6. Setup zram-based swap"
    echo "7. Delete zram swap config"
    echo "8. Exit"
    read -p "Choose an option (1-8): " opt

    case "$opt" in
        1)
            read -p "Enter swap size in GB (1-8): " size
            create_swap_file "$DEFAULT_SWAP" "$size"
            ;;
        2)
            create_usb_swap
            ;;
        3)
            delete_swap_file "$DEFAULT_SWAP"
            ;;
        4)
            auto_mount_usb_devices
            list_usb_devices
            echo -e "\nChoose a USB device to remove swap from:"
            read -p "Enter device number: " usb_choice
            selected_mount=${usb_list[$usb_choice]}
            delete_swap_file "$selected_mount/swapfile"
            ;;
        5)
            setup_ollama_models_dir
            ;;
        6)
            install_zram_swap
            ;;
        7)
            delete_zram_swap
            ;;
        8)
            echo "👋 Exiting script."
            break
            ;;
        *)
            echo "❌ Invalid option."
            ;;
    esac
done

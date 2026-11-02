#!/usr/bin/env bash
set -euo pipefail

# =========================
# Internet Optimization Script (Arch Linux)
# =========================
# Linux equivalents of common Windows CMD network-reset and tuning tricks.
# Safe to run multiple times (idempotent where possible).

# -------------------------
# Dependency checks
# -------------------------
REQUIRED_CMDS=(
  ip
  resolvectl
  sysctl
  nft
)

for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Error: required command '${cmd}' not found. Install it via pacman." >&2
    exit 1
  fi
done

# -------------------------
# Privilege check
# -------------------------
if [[ "${EUID}" -ne 0 ]]; then
  echo "Error: this script must be run as root." >&2
  exit 1
fi

# -------------------------
# Helper functions
# -------------------------
log() {
  printf '[%s] %s\n' "$(date '+%F %T')" "$1"
}

# -------------------------
# 1. Renew IP address (DHCP)
# -------------------------
log "Renewing IP address (DHCP lease)..."

# Bring interfaces down/up safely (skip loopback)
mapfile -t IFACES < <(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$')

for iface in "${IFACES[@]}"; do
  if ip link show "${iface}" | grep -q "state UP"; then
    log "Cycling interface: ${iface}"
    ip link set "${iface}" down
    ip link set "${iface}" up
  fi
done

# -------------------------
# 2. Flush DNS cache
# -------------------------
log "Flushing DNS resolver cache..."
resolvectl flush-caches

# -------------------------
# 3. Reset network stack–related sysctls (Winsock analogue)
# -------------------------
log "Resetting key network sysctl parameters to sane defaults..."

SYSCTL_CONF="/etc/sysctl.d/99-network-tuning.conf"

# Idempotent write
cat >"${SYSCTL_CONF}" <<'EOF'
# Network tuning – safe defaults
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_forward = 0
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
EOF

sysctl --system >/dev/null

# -------------------------
# 4. Optimize TCP settings
# -------------------------
log "Applying TCP performance optimizations..."

cat >"${SYSCTL_CONF}" <<'EOF'
# Network tuning – performance
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_window_scaling = 1

net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
EOF

sysctl --system >/dev/null

# -------------------------
# 5. Block known throttling IP ranges (via nftables)
# -------------------------
log "Configuring nftables rules to block known throttling IP ranges..."

NFT_TABLE="inet throttle_block"
NFT_CHAIN="prerouting"

# Create table if missing
if ! nft list table inet throttle_block >/dev/null 2>&1; then
  nft add table inet throttle_block
fi

# Create chain if missing
if ! nft list chain inet throttle_block prerouting >/dev/null 2>&1; then
  nft add chain inet throttle_block prerouting '{ type filter hook prerouting priority 0; }'
fi

# Idempotent rule addition
BLOCK_IPS=(
  "173.194.55.0/24"
  "206.111.0.0/16"
)

for iprange in "${BLOCK_IPS[@]}"; do
  if ! nft list chain inet throttle_block prerouting | grep -q "${iprange}"; then
    nft add rule inet throttle_block prerouting ip saddr "${iprange}" drop
  fi
done

# -------------------------
# DNS optimization (optional but common)
# -------------------------
log "Setting system DNS to Cloudflare and Google (fallback)..."
resolvectl dns "${IFACES[@]}" 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
resolvectl domain "${IFACES[@]}" "~."

# -------------------------
# Done
# -------------------------
log "Network optimization complete. A reboot is recommended for full effect."

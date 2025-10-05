Create script:

nano provision/provision-scripts/install_wireguard.sh


Example content:

#!/usr/bin/env bash
set -e
apt update && apt install -y wireguard
umask 077
mkdir -p /etc/wireguard
cd /etc/wireguard
wg genkey | tee server_private.key | wg pubkey > server_public.key

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
Address = 10.8.0.1/24
ListenPort = 51820
PrivateKey = $(cat server_private.key)
PostUp = ufw route allow in on wg0 out on eth0; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = ufw route delete allow in on wg0 out on eth0; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOF

sysctl -w net.ipv4.ip_forward=1
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
ufw allow 51820/udp
ufw allow OpenSSH
ufw --force enable
echo "✅ WireGuard installed successfully."


Run:

sudo bash provision/provision-scripts/install_wireguard.sh


Verify:

sudo wg show

D.

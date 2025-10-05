This script generates VPN client configuration files automatically.

Example content:

#!/usr/bin/env bash
set -e
TYPE=${1:-wireguard}
NAME=${2:-client1}
OUT_DIR=/root/clients

mkdir -p $OUT_DIR

if [ "$TYPE" = "wireguard" ]; then
    cd /etc/wireguard
    wg genkey | tee ${OUT_DIR}/${NAME}_private.key | wg pubkey > ${OUT_DIR}/${NAME}_public.key

    cat > ${OUT_DIR}/${NAME}.conf <<EOF
    [Interface]
    PrivateKey = $(cat ${OUT_DIR}/${NAME}_private.key)
    Address = 10.8.0.2/24
    DNS = 1.1.1.1

    [Peer]
    PublicKey = $(cat /etc/wireguard/server_public.key)
    Endpoint = $(curl -s ifconfig.me):51820
    AllowedIPs = 0.0.0.0/0
    EOF

    echo "✅ WireGuard client ${NAME} generated."
else
    echo "⚙️  Generating OpenVPN client ${NAME}"
    cd ~/openvpn-ca
    ./easyrsa build-client-full ${NAME} nopass
    cp pki/issued/${NAME}.crt pki/private/${NAME}.key /etc/openvpn/
    echo "✅ OpenVPN client ${NAME} ready in /etc/openvpn/"
fi


Usage:

bash provision/provision-scripts/generate_client.sh wireguard user1
bash provision/provision-scripts/generate_client.sh openvpn user2

4️⃣

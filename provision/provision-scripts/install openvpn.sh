Connect to VM:

ssh azureuser@<VM_PUBLIC_IP>


Create and edit your script:

nano provision/provision-scripts/install_openvpn.sh


Script content example:

#!/usr/bin/env bash
set -e
apt update && apt install -y openvpn easy-rsa
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-dh
./easyrsa build-server-full server nopass
./easyrsa gen-crl
cp pki/ca.crt pki/private/server.key pki/issued/server.crt /etc/openvpn/
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
systemctl enable openvpn@server
systemctl start openvpn@server
ufw allow 1194/udp
ufw allow OpenSSH
ufw --force enable
echo "✅ OpenVPN installed successfully."


Run it:

sudo bash provision/provision-scripts/install_openvpn.sh

C.

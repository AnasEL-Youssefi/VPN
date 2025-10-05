Diagram:

graph LR
  Client -->|UDP 1194| OpenVPN
  Client -->|UDP 51820| WireGuard
  OpenVPN --> eth0((Internet))
  WireGuard --> eth0((Internet))


Explain:

Azure VM hosts both servers.

Firewall only allows 22, 1194/udp, 51820/udp.

WireGuard uses 10.8.0.0/24 internal subnet.

NAT configured with iptables.


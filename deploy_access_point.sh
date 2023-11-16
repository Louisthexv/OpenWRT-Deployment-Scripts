#!/bin/ash

# Set LAN interface IP address
uci set network.lan.ipaddr='192.168.0.2'  # Set an IP within your primary router's DHCP pool
uci commit network

# Set custom DNS servers in DHCP configuration
uci set dhcp.lan.dhcp_option='6,8.8.8.8,8.8.4.4'  # Use Google's DNS servers; replace with your preferred DNS servers
uci commit dhcp

# Disable DHCP server
uci set dhcp.lan.ignore='1'
uci commit dhcp

# Set wireless configuration for 2.4GHz
uci set wireless.radio0.channel='1'
uci set wireless.radio0.htmode='HT40'
uci set wireless.default_radio0.ssid='Neural_Network_Nexus'
uci set wireless.default_radio0.encryption='psk2'
uci set wireless.default_radio0.key='goodlife'
uci commit wireless

# Set wireless configuration for 5GHz
uci set wireless.radio1.channel='36'
uci set wireless.radio1.htmode='VHT80'  # You can adjust this based on your preference
uci set wireless.default_radio1.ssid='Neural_Network_Nexus'
uci set wireless.default_radio1.encryption='psk2'
uci set wireless.default_radio1.key='goodlife'
uci commit wireless

# Allow DHCP traffic through the firewall
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-DHCP'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].target='ACCEPT'
uci set firewall.@rule[-1].proto='udp'
uci set firewall.@rule[-1].dest_port='67'
uci commit firewall

# Allow DNS traffic through the firewall
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-DNS'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].target='ACCEPT'
uci set firewall.@rule[-1].proto='udp'
uci set firewall.@rule[-1].dest_port='53'
uci commit firewall

# Restart network and wireless
/etc/init.d/network restart
/etc/init.d/network reload
/etc/init.d/wireless restart

# Enable the wireless interfaces
uci set wireless.radio0.disabled='0'
uci set wireless.radio1.disabled='0'
uci commit wireless

# Restart wireless again
/etc/init.d/wireless restart

# Allow SSH (adjust this based on your needs)
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-SSH'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].target='ACCEPT'
uci set firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].dest_port='22'
uci commit firewall

# Restart firewall
/etc/init.d/firewall restart

#
# Cookbook Name:: iptables
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "sysctl.conf" do
  path "/etc/sysctl.conf"
  source "sysctl.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

execute "forward" do
  command "sysctl -p"
end

service 'iptables' do
  action :stop
end

execute "iptable -F" do
  command "iptables -F"
end

execute "nat" do
  command "iptables -t nat -A POSTROUTING -o #{node['iptables']['WAN_NIC']} -s #{node['iptables']['LAN_NETADDR']}/#{node['iptables']['LAN_NETMASK']} -j MASQUERADE"
end
execute "FORWARD 1" do
  command "iptables -I FORWARD 1 -i #{node['iptables']['LAN_NIC']} -o #{node['iptables']['WAN_NIC']} -s #{node['iptables']['LAN_NETADDR']}/#{node['iptables']['LAN_NETMASK']} -j ACCEPT"
end

execute "FORWARD 2" do
  command "iptables -I FORWARD 1 -m state --state ESTABLISHED,RELATED -j ACCEPT"
end
 
execute "save" do
  command "service iptables save"
end

service 'iptables' do
  action :start
end
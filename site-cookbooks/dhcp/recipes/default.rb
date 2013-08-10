#
# Cookbook Name:: dhcp
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "dhcp" do
  action :install
end

template "dhcpd.conf" do
  path "/etc/dhcp/dhcpd.conf" 
  source "dhcpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
#  notifies :reload , 'service[dhcpd]'
end

template "dhcpd" do
  path "/etc/sysconfig/dhcpd"
  source "dhcpd.erb"
  owner "root"
  group "root"
  mode 0644
end

service "dhcpd" do
  supports :status => true,
           :restart => true,
           :reload => true
  action [:enable, :start]
end
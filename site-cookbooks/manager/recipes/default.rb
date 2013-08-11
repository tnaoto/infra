#
# Cookbook Name:: manager
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "8080" do
  command "iptables -A INPUT -p tcp --dport 8080 -j ACCEPT"
end

execute "http" do
  command "iptables -A INPUT -p tcp --dport http -j ACCEPT"
end

package "curl" do
  action :install
end

package "tftp-server" do
  action :install
end

package "tftp" do
  action :install
end

package "syslinux" do
  action :install
end

template "tftp" do
  path "/etc/xinetd.d/tftp"
  source "tftp.erb"
  owner "root"
  group "root"
  mode 0644
end

service "xinetd" do
  action [:restart]
end

template "nginx.repo" do
  path "/etc/yum.repos.d/nginx.repo"
end

package "nginx" do
  action :install
end

template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  notifies :reload, "service[nginx]"
end

service "nginx" do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

execute "8080" do
  command "iptables -A INPUT -p tcp --dport 81 -j ACCEPT"
end

directory '/usr/share/nginx/html/centos6' do
  action :create
  mode 0777
  ignore_failure true
end

execute "mount" do
 command "mount -t iso9660 -o loop /root/CentOS-6.4-x86_64-minimal.iso /usr/share/nginx/html/centos6"
 ignore_failure true
end

file "/var/lib/tftpboot/pxelinux.0" do
  content IO.read("/usr/share/syslinux/pxelinux.0")
end

file "/var/lib/tftpboot/vmlinuz" do
  content IO.read("/root/pxeboot/vmlinuz")
end

file "/var/lib/tftpboot/initrd.img" do
  content IO.read("/root/pxeboot/initrd.img")
end

directory '/var/lib/tftpboot/pxelinux.cfg' do
  action :create
  mode 0777
  ignore_failure true
end

template "default" do
 path "/var/lib/tftpboot/pxelinux.cfg/default"
 source "default.erb"
end

template "ks.cfg" do
  path "/usr/share/nginx/html/ks.cfg"
  source "kc.cfg.erb"
  owner "root"
  group "root"
  mode 0644
end

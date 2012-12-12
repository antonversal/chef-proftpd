#
# Cookbook Name:: proftpd
# Recipe:: source
#
# Author:: Anton Versal (<ant.ver@gmail.com>)
#
# Copyright 2012, Anton Versal
#

include_recipe "build-essential"

proftpd_version = node[:proftpd][:version]

contrib_modules = node[:proftpd][:contrib_modules]
with_includes_flag = []
with_libraries_flag = []

default_libs = []
redhat_libs = []

if contrib_modules.include?(:mod_sql_mysql)
  with_includes_flag << "/usr/local/mysql/include/mysql"
  with_libraries_flag << "/usr/local/mysql/lib/mysql"
end

if contrib_modules.include?(:mod_sql_postgres)
  with_includes_flag << "/usr/local/postgres/include"
  with_libraries_flag << "/usr/local/postgres/lib"
  default_libs << "libpq-dev"
  redhat_libs << "postgresql-libs"
end


if contrib_modules.any? { |m| [:mod_tls, :mod_sql_passwd].include?(m) }
  with_includes_flag << "/usr/local/openssl/include"
  with_libraries_flag << "/usr/local/openssl/lib"
  redhat_libs << "openssl-devel"
  default_libs << "libssl-dev"
end

packages = value_for_platform(
  ["centos", "redhat", "fedora"] => {'default' => redhat_libs},
  "default" => default_libs
)

packages.each do |devpkg|
  package devpkg
end

node.set[:proftpd][:install_path] = "/opt/proftpd-#{proftpd_version}"
node.set[:proftpd][:src_binary] = "#{node[:proftpd][:install_path]}/sbin/proftpd"

configure_flags = ["--prefix=#{node[:proftpd][:install_path]}"]
configure_flags << "--with-modules=#{contrib_modules.join(":")}" if contrib_modules.size > 0
configure_flags << "--with-includes=#{with_includes_flag.join(":")}" if with_includes_flag.size > 0
configure_flags << "--with-libraries=#{with_libraries_flag.join(":")}" if with_libraries_flag.size > 0

node.set[:proftpd][:configure_flags] = configure_flags

remote_file "#{Chef::Config[:file_cache_path]}/proftpd-#{proftpd_version}.tar.gz" do
  source "https://github.com/downloads/proftpd/proftpd.github.com/proftpd-#{proftpd_version}.tar.gz"
  action :create_if_missing
end

bash "compile_proftpd_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf proftpd-#{proftpd_version}.tar.gz
    cd proftpd-#{proftpd_version} && ./configure #{configure_flags.join(" ")}
    make && make install
  EOH
  creates node[:proftpd][:src_binary]
end

user node[:proftpd][:user] do
  comment "proftpd user"
  shell "/bin/false"
  home "/var/run/proftpd"
end

group node[:proftpd][:user] do
  members [node[:proftpd][:user]]
end

directory node[:proftpd][:log_dir] do
  mode 0755
  owner node[:proftpd][:user]
  action :create
end

directory node[:proftpd][:dir] do
  owner "root"
  group "root"
  mode "0755"
end


#install init db script
template "/etc/init.d/proftpd" do
  source "proftpd.init.erb"
  owner "root"
  group "root"
  mode "0755"
end

#register service
service "proftpd" do
  supports :status => true, :restart => true, :reload => true
  action :enable
  subscribes :restart, resources(:bash => "compile_proftpd_source")
end

template "proftpd.conf" do
  path "#{node[:proftpd][:dir]}/proftpd.conf"
  source "proftpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "proftpd"), :immediately
end

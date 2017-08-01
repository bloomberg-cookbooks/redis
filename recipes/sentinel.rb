#
# Cookbook: blp-redis
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

poise_service_user node['redis']['service_user'] do
  shell '/bin/bash'
  group node['redis']['service_group']
  home node['redis']['service_home']
  not_if { user == 'root' }
end

directory node['redis-sentinel']['service_home'] do
  recursive true
  owner node['redis']['service_user']
  group node['redis']['service_group']
  mode '0775'
end

install = redis_installation node['redis-sentinel']['service_name'] do
  notifies :restart, "poise_service[#{name}]", :delayed
end

config = redis_config node['redis-sentinel']['service_name'] do
  path node['redis-sentinel']['config_file']
  owner node['redis']['service_user']
  group node['redis']['service_group']
  notifies :reload, "poise_service[#{name}]", :delayed
  not_if { File.exist?(path) }
end

poise_service node['redis-sentinel']['service_name'] do
  command "#{install.redis_program} #{config.path} --sentinel"
  user node['redis']['service_user']
  directory node['redis']['service_home']
  options :systemd, template: 'blp-redis:systemd.service.erb'
  options :sysvinit, template: 'blp-redis:sysvinit.sh.erb'
  options :upstart, template: 'blp-redis:upstart.conf.erb'
end


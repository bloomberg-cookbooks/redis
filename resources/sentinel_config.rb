#
# Cookbook: blp-redis
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :redis_sentinel_config

include RedisCookbook::ResourceMixin

property :path, String, name_property: true
property :owner, String, default: 'redis'
property :group, String, default: 'redis'
property :mode, String, default: '0440'

property :service_home, String, default: '/var/lib/redis'
property :logfile, String, default: '/var/log/redis/redis-sentinel.log'
property :config_source, String, default: lazy { default_config_source }

# @see: https://github.com/antirez/redis/blob/3.2/sentinel.conf
property :sentinel_port, Integer, default: 26_379
property :sentinel_announce_ip, String
property :sentinel_announce_port, Integer
property :sentinel_master_name, String, default: 'mymaster'
property :sentinel_monitor, String, default: '127.0.0.1 6379 2'
property :sentinel_auth, String, default: 'changeme'
property :sentinel_down, Integer, default: 30_000
property :sentinel_parallel, Integer, default: 1
property :sentinel_failover, Integer, default: 180_000
property :sentinel_notification, [String, NilClass], default: nil
property :sentinel_client_reconfig, [String, NilClass], default: nil

action :create do
  [new_resource.service_home, ::File.dirname(new_resource.path), ::File.dirname(new_resource.logfile)].each do |dirname|
    directory dirname do
      recursive true
      owner new_resource.owner
      group new_resource.group
      not_if { path == '/etc' }
    end
  end
  
  template new_resource.path do
    source "#{new_resource.config_source}/sentinel.conf.erb"
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    variables new_resource: new_resource
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end

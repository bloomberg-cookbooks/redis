#
# Cookbook: blp-redis
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :redis_config

include RedisCookbook::ResourceMixin

property :path, String, name_property: true
property :owner, String, default: 'redis'
property :group, String, default: 'redis'
property :mode, String, default: '0440'

property :service_home, String, default: '/var/lib/redis'
property :logfile, String, default: '/var/log/redis/redis.log'
property :config_source, String, default: lazy { default_config_source }

# @see: https://github.com/antirez/redis/blob/3.2/redis.conf
property :port, Integer, default: 6_379
property :bind, String, default: '0.0.0.0'
property :unixsocket, [String, NilClass], default: nil
property :unixsocketperm, [String, NilClass], default: nil
property :tcp_backlog, [Integer, NilClass], default: nil
property :timeout, Integer, default: 0
property :loglevel, String, default: 'notice'
property :syslog_enabled, [String, NilClass], default: nil
property :syslog_ident, [String, NilClass], default: nil
property :syslog_facility, [String, NilClass], default: nil
property :databases, Integer, default: 16
property :save, [String, Array], default: ['900 1', '300 10', '60 10000']
property :stop_writes_on_bgsave_error, equal_to: %w(yes no), default: 'yes'
property :rdbcompression, equal_to: %w(yes no), default: 'yes'
property :protected_mode, equal_to: %w(yes no), default: 'yes'
property :rdbchecksum, equal_to: %w(yes no), default: 'yes'
property :slaveof, [String, Array, NilClass], default: nil
property :masterauth, [String, NilClass], default: nil
property :slave_serve_stale_data, equal_to: %w(yes no), default: 'yes'
property :slave_read_only, equal_to: %w(yes no), default: 'yes'
property :repl_ping_slave_period, [String, NilClass], default: nil
property :repl_timeout, [String, NilClass], default: nil
property :slave_priority, Integer, default: 100
property :requirepass, [String, NilClass], default: nil
property :maxclients, [String, NilClass], default: nil
property :maxmemory, [String, NilClass], default: nil
property :maxmemory_policy, [String, NilClass], default: nil
property :memory_samples, [String, NilClass], default: nil
property :dbfilename, String, default: 'dump.rdb'
property :appendonly, equal_to: %w(yes no), default: 'no'
property :appendfilename, String, default: 'appendonly.aof'
property :appendfsync, String, default: 'everysec'
property :no_appendfsync_on_rewrite, equal_to: %w(yes no), default: 'no'
property :auto_aof_rewrite_percentage, Integer, default: 100
property :auto_aof_rewrite_min_size, String, default: '64mb'
property :lua_time_limit, Integer, default: 5_000
property :slowlog_log_slower_than, Integer, default: 10_000
property :slowlog_max_len, Integer, default: 128
property :hash_max_ziplist_entries, Integer, default: 512
property :hash_max_ziplist_value, Integer, default: 64
property :list_max_ziplist_entries, Integer, default: 512
property :list_max_ziplist_value, Integer, default: 64
property :set_max_intset_entries, Integer, default: 512
property :zset_max_ziplist_entries, Integer, default: 128
property :zet_max_ziplist_value, Integer, default: 64
property :activerehashing, equal_to: %w(yes no), default: 'yes'
property :client_output_buffer_limit, [String, Array], default: ['normal 0 0 0', 'slave 256mb 64mb 60', 'pubsub 32mb 8mb 60']

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
    source "#{new_resource.config_source}/redis.conf.erb"
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

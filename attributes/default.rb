#
# Cookbook: blp-redis
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

default['redis']['install_provider'] = 'package'

default['redis']['service_user'] = 'redis'
default['redis']['service_group'] = 'redis'
default['redis']['service_home'] = '/var/run/redis'

default['redis']['service_name'] = 'redis'
default['redis']['config_file'] = '/etc/redis.conf'
default['redis']['config'] = {}

default['redis-sentinel']['service_name'] = 'redis-sentinel'
default['redis-sentinel']['config_file'] = '/etc/redis-sentinel.conf'
default['redis-sentinel']['config'] = {}



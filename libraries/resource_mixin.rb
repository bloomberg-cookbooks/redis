#
# Cookbook: blp-redis
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

module RedisCookbook
  module ResourceMixin
    def default_config_source
      case node['platform']
      when 'redhat', 'centos'
        case node['platform_version'].to_i
        when 5 then '2.4'
        when 6 then '2.4'
        when 7 then '2.8'
        end
      when 'ubuntu'
        case node['platform_version'].to_i
        when 12 then '2.2'
        when 14 then '2.8'
        when 16 then '3.0'
        end
      else
        '2.8'
      end      
    end    
  end
end

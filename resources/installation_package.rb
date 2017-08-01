#
# Cookbook: blp-redis
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :redis_installation_package
provides :redis_installation do |node|
  node['redis']['install_provider'] == 'package'
end

property :package_name, String, default: lazy { default_package_name }
property :service_user, String, default: 'redis'
property :service_group, String, default: 'redis'
property :redis_program, String, default: '/usr/bin/redis-server'

def default_package_name
  return 'redis-server' if platform_family? 'debian'
  'redis'
end

action :install do
  file '/etc/init.d/redis' do
    action :nothing
  end

  if platform_family? 'debian'
    cookbook_file '/etc/dpkg/dpkg.cfg.d/redis-server' do
      source 'redis-server.conf'
      owner 'root'
      group node['root_group']
      mode '0444'
    end
  end
  
  package "install #{new_resource.package_name}" do
    package_name new_resource.package_name
    notifies :delete, 'file[/etc/init.d/redis]', :immediately
  end
end

action :uninstall do
  if platform_family? 'debian'
    cookbook_file '/etc/dpkg/dpkg.cfg.d/redis-server' do
      action :delete
    end
  end
  
  package "remove #{new_resource.package_name}" do
    package_name new_resource.package_name

    if platform_family? 'debian'
      action :purge
    else
      action :remove
    end
  end
end

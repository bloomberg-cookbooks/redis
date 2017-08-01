#
# Cookbook: blp-redis
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :redis_installation_archive
provides :redis_installation do |node|
  node['redis']['install_provider'] == 'archive'
end

property :version, String, default: '3.2.3'
property :archive_checksum, default: '674e9c38472e96491b7d4f7b42c38b71b5acbca945856e209cb428fbc6135f15'
property :archive_url, String, default: 'http://download.redis.io/releases/redis-%{version}.tar.gz'
property :prefix, String, default: '/opt/redis'
property :redis_program, String, default: '/usr/local/bin/redis-server'

action_class do
  def install_path
    ::File.join(new_resource.prefix, new_resource.version)
  end
end

action :install do
  include_recipe 'build-essential::default'

  directory new_resource.prefix do
    recursive true
  end
  
  url = new_resource.archive_url % {version: new_resource.version}
  poise_archive url do
    notifies :run, 'bash[make-redis]', :immediately
    destination install_path
    not_if { ::File.exist?(new_resource.redis_program) }
  end

  program = link new_resource.redis_program do
    action :nothing
    to ::File.join(install_path, 'src', 'redis-server')
  end
  
  bash 'make-redis' do
    action :nothing
    cwd install_path
    code 'make'
    notifies :create, program, :immediately
  end
end

action :uninstall do
  link new_resource.redis_program do
    action :delete
    to ::File.join(install_path, 'src', 'redis-server')
  end

  directory new_resource.install_path do
    recursive true
    action :delete
  end
end


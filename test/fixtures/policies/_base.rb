default_source :community
default_source :chef_repo, '..'
cookbook 'blp-redis', path: '../../..'
run_list 'blp-redis::default'
named_run_list :centos, 'sudo::default', 'yum::default', 'yum-epel::default', run_list
named_run_list :debian, 'sudo::default', 'apt::default', run_list
named_run_list :freebsd, 'freebsd::default', run_list
named_run_list :windows, 'windows::default', run_list

default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['users'] = %w(vagrant kitchen)

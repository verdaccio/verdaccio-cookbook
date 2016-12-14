#
# Cookbook Name:: verdaccio
# Recipe:: verdaccio
#

require 'digest'

nodejs_npm 'verdaccio' do
  version node['verdaccio']['version']
end

directory node['verdaccio']['confdir'] do
  recursive true
end

[
  node['verdaccio']['logdir'],
  node['verdaccio']['datadir']
].each do |create_dir|
  directory create_dir do
    owner node['verdaccio']['user']
    group node['verdaccio']['user']
  end
end

admin_add_list = []

node['verdaccio']['users'].each do |user, conf|
  admin_add_list.push(user) if conf['admin']
end

template "#{node['verdaccio']['confdir']}/config.yaml" do
  source 'config.yaml.erb'
  variables(
    admins: admin_add_list
  )
  mode '0444'
  notifies :restart, 'service[verdaccio]', :delayed
end

logrotate_app 'verdaccio' do
  cookbook 'logrotate'
  path "#{node['verdaccio']['logdir']}/verdaccio.log"
  frequency 'daily'
  rotate node['verdaccio']['logdays']
  create '644 root adm'
end

case node['platform_family']
when 'rhel'
  if node['init_package'] == 'systemd'
    template '/usr/lib/systemd/system/verdaccio.service' do
      source 'verdaccio.service.erb'
      mode '0644'
      notifies :run, 'execute[systemd-reload]', :immediately
      notifies :restart, 'service[verdaccio]', :delayed
    end
    execute 'systemd-reload' do
      command 'systemctl daemon-reload'
      action :nothing
    end
  else
    package 'redhat-lsb-core'

    template '/etc/init.d/verdaccio' do
      source 'verdaccio.sysvinit.erb'
      mode '0755'
    end
  end
when 'debian'
  if node['init_package'] == 'systemd'
    template '/lib/systemd/system/verdaccio.service' do
      source 'verdaccio.service.erb'
      mode '0644'
      notifies :restart, 'service[verdaccio]', :delayed
    end
  else
    template '/etc/init/verdaccio.conf' do
      source 'verdaccio.conf.erb'
      notifies :restart, 'service[verdaccio]', :delayed
    end
  end
else
  raise 'Platform not supported'
end

service 'verdaccio' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end

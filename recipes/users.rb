# encoding: utf-8
#
# Cookbook Name:: verdaccio
# Recipe:: users
#

user_account node['verdaccio']['user'] do
  home File.join('/home/', node['verdaccio']['user'])
  password nil
  manage_home true
end

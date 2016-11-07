#
# Cookbook Name:: verdaccio
# Recipe:: default
#

include_recipe 'nodejs'
include_recipe 'verdaccio::users'
include_recipe 'verdaccio::verdaccio'

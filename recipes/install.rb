#
## Installs/configure a basic mongo instance
## Cookbook Name:: greysystems-mongodb
## Recipe:: install
##
## Copyright (C) 2015 GreySystems
##
## All rights reserved - Do Not Redistribute
##
#

case node['platform_family']
when 'rhel', 'redhat'
  package 'initscripts' do
    action :install
  end
end

include_recipe 'greysystems-mongodb::ebs' if node['greysystems_mongo']['ec2']

# includes 10gen repositories (debian/redhat derivates)
node.set['mongodb']['package_version'] = node['greysystems_mongo']['version']
node.set['mongodb']['install_method'] = 'mongodb-org'
node.set['mongodb']['package_name'] = 'mongodb-org'
node.set['mongodb']['config']['dbpath'] = node['greysystems_mongo']['dbpath']

# configure admin user
node.set['mongodb']['admin'] = {
  'username' => node['greysystems_mongo']['admin']['user'],
  'password' => node['greysystems_mongo']['admin']['password'],
  'roles' => node['greysystems_mongo']['admin']['roles'],
  'database' => node['greysystems_mongo']['admin']['database']
}

include_recipe 'mongodb::mongodb_org_repo'
include_recipe 'mongodb::default'

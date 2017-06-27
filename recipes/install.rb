#
## Installs/configure a basic mongo instance
## Cookbook Name:: pushmoney-mongodb
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

include_recipe 'pushmoney-mongodb::ebs' if node['pushmoney_mongo']['ec2']

# includes 10gen repositories (debian/redhat derivates)
node.set['mongodb']['package_version'] = node['pushmoney_mongo']['version']
node.set['mongodb']['install_method'] = 'mongodb-org'
node.set['mongodb']['package_name'] = 'mongodb-org'
node.set['mongodb']['config']['dbpath'] = node['pushmoney_mongo']['dbpath']

# configure admin user
node.set['mongodb']['admin'] = {
  'username' => node['pushmoney_mongo']['admin']['user'],
  'password' => node['pushmoney_mongo']['admin']['password'],
  'roles' => node['pushmoney_mongo']['admin']['roles'],
  'database' => node['pushmoney_mongo']['admin']['database']
}

include_recipe 'mongodb::mongodb_org_repo'
include_recipe 'mongodb::default'

## Configure a replicaset in mongo, using current node as the primary one.
## Replica set members are searched against chef server using node['greysystems_mongo']['repSet']['members']
## Cookbook Name:: greysystems-mongodb
## Recipe:: rconfigure-replicaset
##
## Copyright (C) 201t GreySystems
##
## All rights reserved - Do Not Redistribute
##

# search nodes

search_string = "mongodb_cluster_name:#{node['mongodb']['cluster_name']} AND chef_environment:#{node.chef_environment} AND mongodb_config_replSet:#{node['mongodb']['config']['replSet']}"

rs_nodes = []
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  rs_nodes = search(:node, search_string)
end

unless rs_nodes.empty?
  replicas = []
  rs_nodes.each do |n|
    replicas.push "#{n.ipaddress}:#{n['mongodb']['config']['port']}" if n.name != node.name
  end

  template '/tmp/setup-repset.sh' do
    source 'setup-repset.sh.erb'
    owner 'root'
    group 'root'
    mode 0o755
    variables(secondary_servers: replicas.join(','))
    notifies :run, 'bash[configure-replicaset]', :delayed
  end

  bash 'configure-replicaset' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
      /tmp/setup-repset.sh > configure_rep_set.log
    EOH
    action :nothing
  end
end

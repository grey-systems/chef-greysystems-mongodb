case node['platform_family']
when 'rhel', 'redhat'
  default['greysystems_mongo'] ['version']  = '2.6.7-1'
when 'debian'
  default['greysystems_mongo'] ['version']  = '2.6.7'

end

default['greysystems_mongo']['admin']['user'] = 'admin'
default['greysystems_mongo']['admin']['password'] = '1234561234'
default['greysystems_mongo']['admin']['roles'] = %w[userAdminAnyDatabase dbAdminAnyDatabase]
default['greysystems_mongo']['admin']['database'] = 'admin'
default['greysystems_mongo']['dbpath'] = '/data/mongodb'

default['greysystems_mongo']['ec2'] = true
default['greysystems_mongo']['ebs'] = {
  size: 20,
  mount_point: '/data',
  device_id: 'xvdb'
}

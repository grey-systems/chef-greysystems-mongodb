case node['platform_family']
when 'rhel', 'redhat'
  default['pushmoney_mongo'] ['version']  = '2.6.7-1'
when 'debian'
  default['pushmoney_mongo'] ['version']  = '2.6.7'

end

default['pushmoney_mongo']['admin']['user'] = 'admin'
default['pushmoney_mongo']['admin']['password'] = '1234561234'
default['pushmoney_mongo']['admin']['roles'] = %w[userAdminAnyDatabase dbAdminAnyDatabase]
default['pushmoney_mongo']['admin']['database'] = 'admin'
default['pushmoney_mongo']['dbpath'] = '/data/mongodb'

default['pushmoney_mongo']['ec2'] = true
default['pushmoney_mongo']['ebs'] = {
  size: 20,
  mount_point: '/data',
  device_id: 'xvdb'
}

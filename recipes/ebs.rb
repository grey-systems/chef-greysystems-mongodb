#
# Installs/configure an ebs volume
# Cookbook Name:: greysystems-mongodb
# Recipe:: default
#
# Copyright (C) 2015 GreySystems
#
# All rights reserved - Do Not Redistribute
##
# Installs/configure an ebs volume
# Cookbook Name:: greysystems-mongodb
# Recipe:: default
#
# Copyright (C) 2015 GreySystems
#
# All rights reserved - Do Not Redistribute
#
if !node['cloud'].nil? && node['cloud']['provider'] == 'ec2' # the latter check uses Ohai's cloud detection
  include_recipe 'aws'
  # selinux should be disabled to make mongo work with an ebs (an external mount point)
  include_recipe 'selinux::disabled'
  aws = data_bag_item('aws', 'main')

  device_id = "/dev/#{node['greysystems_mongo']['ebs']['device_id']}"

  # create and attach the volume to the device determined above
  aws_ebs_volume 'mongodb-volume' do
    aws_access_key aws['aws_access_key_id']
    aws_secret_access_key aws['aws_secret_access_key']
    size node['greysystems_mongo']['ebs']['size']
    device device_id.gsub('xvd', 'sd') # aws uses sdx instead of xvdx
    action %i[create attach]
  end

  # wait for the drive to attach, before making a filesystem
  ruby_block 'sleeping_data_volume' do
    block do
      timeout = 0
      until File.blockdev?(device_id) || timeout == 1000
        Chef::Log.debug("device #{device_id} not ready - sleeping 10s")
        timeout += 10
        sleep 10
      end
    end
  end

  directory node['greysystems_mongo']['ebs']['mount_point'] do
    owner 'root'
    group 'root'
    mode 0o0755
    recursive true
    action :create
  end

  mount_point = node['greysystems_mongo']['ebs']['mount_point']

  # create a filesystem
  execute 'mkfs' do
    command "mkfs -t ext4 #{device_id}"
    # only if it's not mounted already
    not_if "grep -qs #{mount_point} /proc/mounts"
  end

  # now we can enable and mount it and we're done!
  mount mount_point.to_s do
    device device_id
    fstype 'ext4'
    options 'noatime'
    action %i[enable mount]
  end
end

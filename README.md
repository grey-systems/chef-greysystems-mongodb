Master Branch: [![Build Status](https://travis-ci.org/grey-systems/chef-greysystems-mongodb.svg?branch=master)](https://travis-ci.org/grey-systems/chef-greysystems-mongodb)
Develop Branch:  [![Build Status](https://travis-ci.org/grey-systems/chef-greysystems-mongodb.svg?branch=develop)](https://travis-ci.org/grey-systems/chef-greysystems-mongodb)

# greysystems-mongodb Cookbook

Wrapper cookbook over [mongodb](https://supermarket.chef.io/cookbooks/mongodb) cookbook that installs and configures MongoDB, supporting:

* Single MongoDB instance
* EC2 installation including creation/attach/format/mount of an EBS volume
* Replication


## REQUIREMENTS:

 This cookbook depends on these external cookbooks:

 - mongodb
 - aws
 - selinux

### Platform:

* Chef client version >= 12 (not tested on 13)
* Centos 7

Any RHEL platform should be supported but it's not tested.

## ATTRIBUTES:

Check for information about all attributes that can be configured in [mongodb](https://supermarket.chef.io/cookbooks/mongodb) cookbook

Apart from the attributes defined in mongodb community cookbook, this cookbook also supports:


### EBS specific attributes:

* `node['greysystems_mongo']['ec2']` - EC2 mode, defaults to true. If you are not using an EC2 instance, please setup this variable to false
* `node['greysystems_mongo']['ebs']['size']` - Size of the EBS volume to mount on the node, expressed in GB, defaults to 20. If `node['greysystems_mongo']['ec2']` = false, it's not taken into account
* `node['greysystems_mongo']['ebs']['mount_point']` - Mount poinf of the volume, defaults to `/data`. If `node['greysystems_mongo']['ec2']` = false, it's not taken into account
* `node['greysystems_mongo']['ebs']['device_id']` - Device id of the EBS volume, defaults to `/xvdb`. If `node['greysystems_mongo']['ec2']` = false, it's not taken into account

## USAGE:

### Single mongodb instance

Simply add

```ruby
include_recipe "greysystems-mongodb::default"
```

to your recipe. This will run the mongodb instance as configured by your distribution.

### Replicasets

* Setup the same value for attributes  `node[:mongodb][:cluster_name]` and `node[:mongodb][:config][:replSet]` in any member of the cluster (primary and secondaries)
* Launch and configure FIRST the replicaset's nodes. They must be up and running before the primary's node is configured.
* For replicaset's member, add the following recipe to his run_list:
```ruby
include_recipe "greysystems-mongodb::default"
```
* For primary's node, apart from adding the default recipe, include `configure-replicaset` recipe:
```ruby
include_recipe "greysystems-mongodb::default"
include_recipe "greysystems-mongodb::configure_relicaset"
```

Testing
----------
Due to the nature of AWS, local testing EBS features is not supported at this moment.

For testing the rest of features, this cookbook has an in-place kitchen.yml ready to work with docker

``` bash
# install dependencies
chef exec bundle install
# converge node
chef exec bundle exec rake converge
# verify (integration tests)
chef exec bundle exec rake verify
# full tests (style, converge, verify, destroy docker isntance)
chef exec bundle exec rake full

```


Contributing
------------
Everybody is welcome to contribute. Please, see [`CONTRIBUTING`][contrib] for further information.

[contrib]: CONTRIBUTING.md

Bug Reports
-----------

Bug reports can be sent directly to authors and/or using github's issues.


-------

Copyright (c) 2017 Grey Systems ([www.greysystems.eu](http://www.greysystems.eu))

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

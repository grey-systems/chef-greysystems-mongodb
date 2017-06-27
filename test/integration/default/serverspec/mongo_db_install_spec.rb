# noinspection RubyResolve

require 'serverspec'
require 'test_helper'

# Required by serverspec
set :backend, :exec

describe package('mongodb-org'), if: os[:family] == 'debian' do
  it { should be_installed.by('apt').with_version($node['pushmoney_mongo']['version']) }
end
describe package('mongodb-org'), if: os[:family] == 'redhat' do
  it { should be_installed.with_version($node['pushmoney_mongo']['version']) }
end

describe service('mongod') do
  it { should be_enabled }
  it { should be_running }
end

describe port(27_017) do
  it { should be_listening }
end

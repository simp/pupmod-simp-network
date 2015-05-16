require 'spec_helper'

describe 'network' do

  it { should create_class('network') }
  it { should contain_service('network').with_ensure('running') }
  it { should create_file('/usr/local/sbin/careful_network_restart.sh') }
end

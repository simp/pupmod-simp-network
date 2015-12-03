require 'spec_helper'

describe 'network' do

  it { is_expected.to create_class('network') }
  it { is_expected.to contain_service('network').with_ensure('running') }
  it { is_expected.to create_file('/usr/local/sbin/careful_network_restart.sh') }
end

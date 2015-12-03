require 'spec_helper'

describe 'network::global' do
  # Look in hieradata/default.yaml for variables that were set for this test.

  it { is_expected.to create_class('network::global') }
  it { is_expected.to create_file('/etc/sysconfig/network').with_content(/GATEWAY=1\.2\.3\.4/) }
end

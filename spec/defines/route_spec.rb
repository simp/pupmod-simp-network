require 'spec_helper'

describe 'network::route' do

  let(:title) {'test_route'}
  let(:params) {{
    :interface    => 'test_eth',
    :cidr_netmask => '1.2.3.4/32',
    :next_hop     => '1.2.3.5'
  }}

  it { is_expected.to create_file('/etc/sysconfig/network-scripts/route-test_eth') }
end

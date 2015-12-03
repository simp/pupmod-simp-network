require 'spec_helper'

describe 'network::add_eth' do
  let(:facts) {{
    :operatingsystemmajrelease => '6'
  }}

  context 'base' do
    let(:title) {'test_eth'}
    let(:params) {{
      :bonding   => false,
      :bootproto => 'dhcp',
      :delay     => '0',
      :ensure    => 'present',
      :hwaddr    => 'CA:FE:BA:BE:00:FF'
    }}

    it { should create_file('/etc/sysconfig/network-scripts/ifcfg-test_eth').with_content(/^BOOTPROTO=dhcp/) }
    it { should create_file('/etc/sysconfig/network-scripts/ifcfg-test_eth').with_content(/^HWADDR=CA:FE:BA:BE:00:FF/) }
    it { should create_file('/etc/sysconfig/network-scripts/ifcfg-test_eth').without_content(/^(?!\w|#|\s*$)/) }
  end

  context 'bond' do
    let(:title) {'test_bond'}
    let(:params) {{
      :bonding     => true,
      :bond_miimon => '100',
      :bond_mode   => '4',
      :bootproto   => 'none',
      :onboot      => 'yes',
      :mtu         => '9000',
      :userctl     => 'no',
    }}

    it { should create_file('/etc/sysconfig/network-scripts/ifcfg-test_bond').with_content(/^BONDING_OPTS='miimon=100 mode=4'/) }
    it { should create_file('/etc/sysconfig/network-scripts/ifcfg-test_bond').without_content(/^(?!\w|#|\s*$)/) }
  end
end

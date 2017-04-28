require 'spec_helper'

describe 'network::eth' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'with default parameters' do
          let(:title) { 'default_eth' }
          let(:expected) { File.read('spec/expected/default_eth') }
          it { is_expected.to create_file('/etc/sysconfig/network-scripts/ifcfg-default_eth').with_content(expected) }
        end

        context 'when configuring a bridge' do
          let(:title) {'test_br'}
          let(:params) {{ :bridge => 'br0' }}
          it { is_expected.to create_package('bridge-utils') }
        end

        context 'base' do
          let(:title) {'test_eth'}
          let(:params) {{
            :bonding   => false,
            :bootproto => 'dhcp',
            :delay     => 0,
            :ensure    => 'present',
            :hwaddr    => 'CA:FE:BA:BE:00:FF'
          }}

          it { is_expected.to create_file('/etc/sysconfig/network-scripts/ifcfg-test_eth').with_content(/^BOOTPROTO=dhcp/) }
          it { is_expected.to create_file('/etc/sysconfig/network-scripts/ifcfg-test_eth').with_content(/^HWADDR=CA:FE:BA:BE:00:FF/) }
          it { is_expected.to create_file('/etc/sysconfig/network-scripts/ifcfg-test_eth').without_content(/^(?!\w|#|\s*$)/) }
        end

        context 'bond' do
          let(:title) {'test_bond'}
          let(:params) {{
            :bonding     => true,
            :bond_miimon => 100,
            :bond_mode   => 4,
            :bootproto   => 'none',
            :onboot      => true,
            :mtu         => 9000,
            :userctl     => true
          }}

          it { is_expected.to create_file('/etc/sysconfig/network-scripts/ifcfg-test_bond').with_content(/^BONDING_OPTS='miimon=100 mode=4'/) }
          it { is_expected.to create_file('/etc/sysconfig/network-scripts/ifcfg-test_bond').without_content(/^(?!\w|#|\s*$)/) }
        end

        context 'with everything set' do
          let(:title) { 'everything_eth' }
          let(:params) {{
            :arp                              => true,
            :auto_discover_mac                => true,
            :bonding                          => true,
            :bond_arp_interval                => 5,
            :bond_arp_ip_target               => '192.168.1.1',
            :bond_downdelay                   => 2,
            :bond_lacp_rate                   => 1,
            :bond_max_bonds                   => 5,
            :bond_miimon                      => 100,
            :bond_mode                        => 4,
            :bond_primary                     => 'eth0',
            :bond_updelay                     => 3,
            :bond_use_carrier                 => 1,
            :bond_xmit_hash_policy            => 'layer2+3',
            :bootproto                        => 'dhcp',
            :bridge                           => 'br0',
            :broadcast                        => '255.255.255.255',
            :delay                            => 5,
            :dhclient_ignore_gateway          => true,
            :dhclient_request_option_list     => ['broadcast-address','time-offset','routers'],
            :dhclient_timeout                 => 9999,
            :dhclient_vendor_class_identifier => 'SIMPy dhclient',
            :dhcp_hostname                    => 'dhcp.host.name',
            :dhcprelease                      => 'yes',
            :dns1                             => '8.8.8.8',
            :dns2                             => '8.8.4.4',
            :ethtool_opts                     => ['speed','100','duplex','full','autoneg','off'],
            :ensure                           => 'present',
            :reorder_hdr                      => true,
            :gateway                          => '10.0.2.2',
            :hotplug                          => true,
            :hwaddr                           => 'aa:bb:cc:dd:ee:ff',
            :ipaddr                           => '10.0.2.15',
            :ipv6_autoconf                    => true,
            :ipv6_control_radvd               => true,
            :ipv6_mtu                         => 1500,
            :ipv6_privacy                     => 'rfc3041',
            :ipv6_radvd_pidfile               => '/var/run/radvd',
            :ipv6_radvd_trigger_action        => 'SIGHUP',
            :ipv6_router                      => true,
            :ipv6addr                         => '3ffe:ffff:0:5::1',
            :ipv6addr_secondaries             => ['3ffe:ffff:0:1::10','3ffe:ffff:0:2::11'],
            :ipv6init                         => true,
            :ipv6to4_ipv4addr                 => '10.0.0.5',
            :ipv6to4_mtu                      => 1500,
            :ipv6to4_relay                    => '::192.88.99.1',
            :ipv6to4_routing                  => 'eth0-:0004::1/64 eth1-:0005::1/64',
            :ipv6to4init                      => true,
            :isalias                          => true,
            :linkdelay                        => 5,
            :macaddr                          => 'aa:bb:cc:dd:ee:ff',
            :master                           => 'bind0a',
            :metric                           => 'xyz',
            :mtu                              => 15,
            :net_type                         => 'Bridge',
            :netmask                          => '255.255.255.0',
            :network                          => '10.0.0.0',
            :nozeroconf                       => 'set',
            :onboot                           => false,
            :peerdns                          => true,
            :physdev                          => 'eth1',
            :persistent_dhclient              => true,
            :slave                            => true,
            :srcaddr                          => '10.0.2.14',
            :userctl                          => true,
            :vlan                             => true,
            :vlan_name_type                   => 'VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD',
            :window                           => 15,
            :auto_restart                     => true,
          }}
          let(:expected) { File.read('spec/expected/everything_eth') }
          it { is_expected.to create_file('/etc/sysconfig/network-scripts/ifcfg-everything_eth').with_content(expected) }
        end

      end
    end
  end
end

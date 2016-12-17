require 'spec_helper'

describe 'network::global' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        # Look in hieradata/default.yaml for variables that were set for this test.
        context 'with default parameters' do
          let(:expected) { File.read('spec/expected/default_sysconfig_network') }
          it { is_expected.to create_class('network::global') }
          it { is_expected.to create_exec('global_network_restart').with_command('/sbin/service network restart') }
          it { is_expected.to create_file('/etc/sysconfig/network').with_content(expected) }
        end

        context 'with every parameter set' do
          let(:params) {{
            :gateway             => '192.0.0.1',
            :gatewaydev          => 'br0',
            :hostname            => 'real.host.name',
            :ipv6_autoconf       => true,
            :ipv6_autotunnel     => true,
            :ipv6_defaultdev     => 'tun6to4',
            :ipv6_defaultgw      => '3ffe:fff:1234:5678::1%eth0',
            :ipv6_router         => true,
            :ipv6forwarding      => true,
            :network             => '10.0.0.0',
            :networkdelay        => 5,
            :networking          => true,
            :networking_ipv6     => true,
            :nisdomain           => 'host.name',
            :nozeroconf          => true,
            :peerdns             => true,
            :vlan                => true,
            :auto_restart        => true,
            :persistent_dhclient => true,
          }}
          let(:expected) { File.read('spec/expected/fancy_sysconfig_network') }
          it { is_expected.to create_file('/etc/sysconfig/network').with_content(expected) }
        end

      end
    end
  end
end

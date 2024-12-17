require 'spec_helper'

describe 'network::route' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context 'with basic settings' do
          let(:title) { 'test_route' }
          let(:params) do
            {
              interface: 'test_eth',
           cidr_netmask: '1.2.3.4/32',
           next_hop: '1.2.3.5'
            }
          end

          it { is_expected.to create_concat('route_test_eth') }
          it { is_expected.to create_concat_fragment('route_test_eth+test_route').with_content("1.2.3.4/32 via 1.2.3.5\n") }
        end

        context 'with multiple routes for the same interface' do
          let(:pre_condition) do
            %(
            network::route{ 'another_route':
              interface    => 'test_eth',
              cidr_netmask => '2.3.4.5/32',
              next_hop     => '2.3.4.6'
            }
          )
          end
          let(:title) { 'test_route' }
          let(:params) do
            {
              interface: 'test_eth',
           cidr_netmask: '1.2.3.4/32',
           next_hop: '1.2.3.5'
            }
          end

          it { is_expected.to create_concat('route_test_eth') }
          it { is_expected.to create_concat_fragment('route_test_eth+test_route').with_content("1.2.3.4/32 via 1.2.3.5\n") }
          it { is_expected.to create_concat_fragment('route_test_eth+another_route').with_content("2.3.4.5/32 via 2.3.4.6\n") }
        end
      end
    end
  end
end

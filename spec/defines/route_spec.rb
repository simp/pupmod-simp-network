require 'spec_helper'

describe 'network::route' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context 'with basic settings' do
          let(:title) {'test_route'}
          let(:params) {{
            :interface    => 'test_eth',
            :cidr_netmask => '1.2.3.4/32',
            :next_hop     => '1.2.3.5'
          }}
          it { is_expected.to create_concat('route_test_eth') }
          it { is_expected.to create_concat_fragment('route_test_eth+test_route').with_content("1.2.3.4/32 via 1.2.3.5\n") }
        end

      end
    end
  end
end

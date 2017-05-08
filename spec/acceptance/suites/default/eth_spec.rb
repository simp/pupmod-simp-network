require 'spec_helper_acceptance'

test_name 'network::eth class'

describe 'network::eth class' do
  let(:manifest) { <<-EOF
    include 'network'

    network::eth { 'br0':
      net_type  => 'Bridge',
      onboot    => true,
      macaddr   => $facts['macaddress_eth1'],
      require   => Network::Eth['eth1'],
      ipaddr    => '10.0.2.20',
      gateway   => '10.0.2.2',
      broadcast => '255.255.255.0',
      dns1      => '8.8.8.8'
    }
    network::eth { 'eth1':
      bridge  => 'br0',
      macaddr => $facts['macaddress_eth1'],
    }
    EOF
  }

  context 'on each host' do
    hosts.each do |host|
      it 'should work with no errors' do
        apply_manifest_on(host, manifest, :catch_failures => true)
        apply_manifest_on(host, manifest, :catch_failures => true)
      end
      it 'should be idempotent once stable' do
        apply_manifest_on(host, manifest, :catch_changes => true)
      end

      ['eth0','br0'].each do |nic|
        it "should have #{nic} as devices" do
          sleep 15
          device = on host, "ip address show dev #{nic}"
          expect(device.stdout).to match(/#{nic}/)
          expect(device.stdout).to match(/inet/)
        end
      end

    end
  end

end

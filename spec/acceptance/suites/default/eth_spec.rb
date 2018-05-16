require 'spec_helper_acceptance'

test_name 'network::eth class'

describe 'network::eth class' do
  let(:manifest) { <<-EOF
    include 'network'

    network::eth { 'br0':
      net_type  => 'Bridge',
      onboot    => true,
      macaddr   => $facts['macaddress_#{@interfaces.last}'],
      require   => Network::Eth['#{@interfaces.last}'],
      ipaddr    => '10.0.2.20',
      gateway   => '10.0.2.2',
      broadcast => '255.255.255.0',
      dns1      => '8.8.8.8'
    }

    network::eth { '#{@interfaces.last}':
      bridge  => 'br0',
      macaddr => $facts['macaddress_#{@interfaces.last}'],
    }
    EOF
  }

  hosts.each do |host|
    context "on #{host}" do
      before(:all) do
        # All interfaces with bridges and loopback removed
        @interfaces = pfact_on(host, 'interfaces').split(',').delete_if{|i| i =~ /^(br|lo)/}
      end

      it 'should work with no errors' do
        apply_manifest_on(host, manifest, :catch_failures => true)
        apply_manifest_on(host, manifest, :catch_failures => true)
      end

      it 'should be idempotent once stable' do
        apply_manifest_on(host, manifest, :catch_changes => true)
      end

      it 'should have br0 as a device' do
        sleep 15
        device = on host, 'ip address show dev br0'
        expect(device.stdout).to match(/br0/)
        expect(device.stdout).to match(/inet/)
      end
    end
  end
end

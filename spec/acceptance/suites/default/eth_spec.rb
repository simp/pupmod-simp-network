require 'spec_helper_acceptance'

test_name 'network::eth class'

describe 'network::eth class' do
  let(:manifest) { <<-EOF
    include 'network'

    network::eth { 'br0':
      net_type  => 'Bridge',
      onboot    => true,
      macaddr   => $facts['macaddress_#{@tgt_iface}'],
      require   => Network::Eth['#{@tgt_iface}'],
      ipaddr    => $facts['ipaddress_#{@tgt_iface}'],
      gateway   => $facts['defaultgateway'],
      broadcast => $facts['netmask_#{@tgt_iface}'],
      dns1      => '8.8.8.8'
    }

    network::eth { '#{@tgt_iface}':
      bridge  => 'br0',
      macaddr => $facts['macaddress_#{@tgt_iface}'],
    }
    EOF
  }

  hosts.each do |host|
    context "on #{host}" do
      before(:all) do
        # All interfaces with bridges and loopback removed
        @tgt_iface = pfact_on(host, 'interfaces').split(',').delete_if{|i| i =~ /^(br|lo)/}.last.strip
      end

      it 'should work with no errors' do
        apply_manifest_on(host, manifest, :catch_failures => true)
        apply_manifest_on(host, manifest, :catch_failures => true)
      end

      it 'should be idempotent once stable' do
        apply_manifest_on(host, manifest, :catch_changes => true)
      end

      it 'should have br0 as a device' do
        # Need to wait for the interface to restart fully after the puppet run
        sleep 30
        device = on host, 'ip address show dev br0'
        expect(device.stdout).to match(/br0/)
        expect(device.stdout).to match(/inet/)
      end
    end
  end
end

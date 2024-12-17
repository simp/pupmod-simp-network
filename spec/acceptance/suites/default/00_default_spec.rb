require 'spec_helper_acceptance'

test_name 'network::eth class'

describe 'network::eth class' do
  let(:manifest) do
    <<-MANIFEST
    include 'network::global'

    network::eth { 'br0':
      bootproto     => 'static',
      net_type      => 'Bridge',
      onboot        => true,
      macaddr       => $facts['macaddress_#{@tgt_iface}'],
      ipaddr        => pick($facts['ipaddress_#{@tgt_iface}'], $facts['ipaddress_br0']),
      gateway       => $facts['defaultgateway'],
      broadcast     => $facts['netmask_#{@tgt_iface}'],
      dns1          => '8.8.8.8',
      require       => Network::Eth['#{@tgt_iface}'],
      auto_restart  => true,
      nm_controlled => #{nm_controlled}
    }

    network::eth { '#{@tgt_iface}':
      bridge       => 'br0',
      macaddr      => $facts['macaddress_#{@tgt_iface}'],
      auto_restart => true,
      nm_controlled => #{nm_controlled}
    }
    MANIFEST
  end

  $test_suts = 0
  $nm_suts   = 0
  hosts.each do |host|
    [true, false].each do |enable_nm|
      legacy_network_available = (on(host, 'service network status', accept_all_exit_codes: true).exit_code == 0)

      next unless enable_nm || legacy_network_available

      nm_fact = on(host, 'which nmcli', accept_all_exit_codes: true)
      nm_enabled = enable_nm && (nm_fact.exit_code == 0) && !nm_fact.stdout.strip.empty?

      $test_suts += 1
      $nm_suts   += 1 if nm_enabled

      context "on #{host}#{nm_enabled ? ' (using Network Manager)' : ' (using network)'})" do
        let(:nm_controlled) { nm_enabled }

        before :all do
          # The Beaker-generated Vagrantfile brings up a box with two networks:
          #
          #   * A public network for SSH & internet access
          #   * A private network for cross-SUT access
          #
          # Am SUT's final external interface always connects to the private network,
          # which we will use to configure during these tests
          @tgt_iface = on(host, facter('interfaces'), silent: true).stdout.split(',').delete_if { |i| i =~ %r{^(br|lo)} }.last.strip
        end

        context 'when creating a bridged interface' do
          it 'works with no errors' do
            apply_manifest_on(host, manifest, catch_failures: true)
            # Is this second apply still needed?
            apply_manifest_on(host, manifest, catch_failures: true)
          end

          it 'is idempotent once stable' do
            apply_manifest_on(host, manifest, catch_changes: true)
          end

          it 'has device br0' do
            # Need to wait for the interface to restart fully after the puppet run
            sleep 30
            device = on host, 'ip address show dev br0'
            expect(device.stdout).to match(%r{br0})
          end

          it 'has device br0 connected to the network' do
            device = on host, 'ip address show dev br0'
            expect(device.stdout).to match(%r{inet})
          end
        end
      end
    end
  end

  after :all do
    expect($test_suts).to be > 0
    expect($nm_suts).to be > 0, 'No SUTs tested with NetworkManager'
    # Is this a good idea?
    ### expect($nm_suts).to be < $test_suts, 'No SUTs tested with network (without NetworkManager)'
  end
end

# == Define: network::add_eth
#
# This sets up a particular ethernet device config file.
#
# See /usr/share/doc/initscripts-<version>/sysconfig.txt for details of
# each option.
#
# For bonding options see /usr/share/doc/iputils-20020927/README.bonding.
# Particularly, section "3.2 Configuration with Initscripts Support" and
# "2. Bonding Driver Options".
#
# DEVICE is taken from $name
# HWADDR is pulled from facter if possible.
# ONBOOT is aliased to ONPARENT for alias devices
#
# This does require that you include 'network::redhat' to get the network
# service defined.
#
# == Parameters
#
# [*name*]
#   DEVICE is taken from this variable.
#
# [*auto_discover_mac*]
#   Determine whether or not the system should try and auto-discover a MAC
#   address for the interface specified.
#
# [*bonding]
#   This variable does not translate into an init script option. If you set
#   this to true instead of false any hardware address auto-discovery will be
#   ignored. Otherwise, the interface will attempt to auto-discover the
#   interface. If you explicitly set hwaddr or macaddr, then this will be
#   ignored.
#
# [*bond_arp_interval*]
# [*bond_arp_ip_target*]
# [*bond_downdelay*]
# [*bond_lacp_rate*]
# [*bond_max_bonds*]
# [*bond_miimon*]
# [*bond_mode*]
# [*bond_primary*]
# [*bond_updelay*]
# [*bond_use_carrier*]
# [*bond_xmit_hash_policy*]
# [*bootproto*]
# [*bridge*]
# [*broadcast*]
# [*delay*]
#   If hosting VMs, set delay to 0.
#
# [*dhclient_ignore_gateway*]
#
# The following 3 options are passed as dhclientargs.
#
# [*dhclient_request_option_list*]
# [*dhclient_timeout*]
# [*dhclient_vendor_class_identifier*]
# [*dhcp_hostname*]
# [*dhcpclass*]
# [*dhcprelease*]
# [*dns1*]
# [*dns2*]
# [*ethtool_opts*]
# [*ensure*]
# [*reorder_hdr*]
# [*gateway*]
# [*hotplug*]
# [*hwaddr*]
#   If you set this, you have the following options:
#     1) Leave Blank -> Auto-detect (default)
#     2) Set to something with ':' -> Set to MAC address (if valid)
#     3) Set to anything else -> Leave unset and add a comment
#
# [*ipaddr*]
# [*ipv6_autoconf*]
# [*ipv6_control_radvd*]
# [*ipv6_mtu*]
# [*ipv6_privacy*]
# [*ipv6_radvd_pidfile*]
# [*ipv6_radvd_trigger_action*]
# [*ipv6_router*]
# [*ipv6addr*]
# [*ipv6addr_secondaries*]
# [*ipv6init*]
# [*ipv6to4_ipv4addr*]
# [*ipv6to4_mtu*]
# [*ipv6to4_relay*]
# [*ipv6to4_routing*]
# [*ipv6to4init*]
# [*isalias*]
# [*linkdelay*]
# [*macaddr*]
#     If you set this variable, it will override any setting for $hwaddr!
#
# [*master*]
# [*metric*]
# [*mtu*]
# [*net_type*]
# [*netmask*]
# [*network*]
# [*nozeroconf*]
# [*onboot*]
# [*peerdns*]
# [*persistent_dhclient*]
# [*slave*]
# [*srcaddr*]
# [*userctl*]
# [*window*]
# [*auto_restart*]
#   Restart the network if necessary due to a configuration change.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
define network::add_eth (
  $arp = '',
  $auto_discover_mac = true,
  $bonding = false,
  $bond_arp_interval = '',
  $bond_arp_ip_target = '',
  $bond_downdelay = '',
  $bond_lacp_rate = '',
  $bond_max_bonds = '',
  $bond_miimon = '',
  $bond_mode = '',
  $bond_primary = '',
  $bond_updelay = '',
  $bond_use_carrier = '',
  $bond_xmit_hash_policy = '',
  $bootproto = 'dhcp',
  $bridge = '',
  $broadcast = '',
  $delay = '',
  $dhclient_ignore_gateway = '',
  $dhclient_request_option_list = '',
  $dhclient_timeout = '10080',
  $dhclient_vendor_class_identifier = '',
  $dhcp_hostname = '',
  $dhcpclass = '',
  $dhcprelease = '',
  $dns1 = '',
  $dns2 = '',
  $ethtool_opts = '',
  $ensure = 'present',
  $reorder_hdr = 'yes',
  $gateway = '',
  $hotplug = '',
  $hwaddr = '',
  $ipaddr = '',
  $ipv6_autoconf = '',
  $ipv6_control_radvd = '',
  $ipv6_mtu = '',
  $ipv6_privacy = 'rfc3041',
  $ipv6_radvd_pidfile = '',
  $ipv6_radvd_trigger_action = '',
  $ipv6_router = '',
  $ipv6addr = '',
  $ipv6addr_secondaries = '',
  $ipv6init = '',
  $ipv6to4_ipv4addr = '',
  $ipv6to4_mtu = '',
  $ipv6to4_relay = '',
  $ipv6to4_routing = '',
  $ipv6to4init = '',
  $isalias = '',
  $linkdelay = '',
  $macaddr = '',
  $master = '',
  $metric = '',
  $mtu = '',
  $net_type = '',
  $netmask = '',
  $network = '',
  $nozeroconf = '',
  $onboot = 'yes',
  $peerdns = '',
  $physdev = '',
  $persistent_dhclient = '',
  $slave = '',
  $srcaddr = '',
  $userctl = '',
  $vlan = false,
  $vlan_name_type = '',
  $window = '',
  $auto_restart = true
) {
  include 'network'

  validate_bool($auto_restart)
  validate_array_member($ensure, ['absent','present'])
  validate_bool($auto_discover_mac)
  validate_bool($bonding)

  if ! empty($macaddr) {
    validate_macaddress($macaddr)
  }
  if ! empty($hwaddr) {
    validate_macaddress($hwaddr)
  }
  validate_bool($vlan)


  if $ensure == 'absent' {
    file { "/etc/sysconfig/network-scripts/ifcfg-$name":
      ensure => 'absent'
    }

    exec { "/sbin/ifdown $name":
      onlyif => "/sbin/ip link show up | /usr/bin/tr -d ' ' | /bin/grep '^[[:digit:]]' | /bin/cut -f2 -d':' | /bin/grep -q '^${name}$'",
      notify => File["/etc/sysconfig/network-scripts/ifcfg-$name"]
    }
  }
  else {
    file { "/etc/sysconfig/network-scripts/ifcfg-$name":
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('network/eth.erb'),
      notify  => Exec["network_restart_$name"]
    }

    if $net_type == 'Bridge' or $bridge != '' or $bonding or $slave != '' {
      exec { "network_restart_$name":
        command     => '/bin/true',
        refreshonly => true,
        notify      => Service['network']
      }
    }
    else {
      # Refresh this interface if:
      #   - we don't have information about it
      #   - we have special knowledge that it needs to be reconfigured.
      # Otherwise, refresh it only when prodded by another resource change.
      #
      # NOTE: If the ipaddress fact is '127.0.0.1' or a non-ip (like 'FORCE'),
      # add_eth will *always* force a refresh.  This works around a fatal error
      # caused by the core fact 'ipaddress' and enables 'puppet apply' to
      # configure an offline system.
      #
      # TODO: lotsa-logic; should probably be a custom type by this point:
      $refreshonly    = inline_template('<%=
        result = "false"
        safe_if_name   = "ipaddress_#{@name.gsub(/\.|:/,\'_\')}"
        ip_fact_exists = has_variable?( safe_if_name )
        if ip_fact_exists
          result         = "true"
          bootproto      = (scope.lookupvar( "bootproto" ))
          ip_fact_value  = (scope.lookupvar( safe_if_name ))
          ip_param_value = (scope.lookupvar( "ipaddr" ))

          # special cases to always refresh:
          #   - ipaddress is nonsense (workaround to no-net ipaddress bug)
          #   - $name is static and ipaddress_$name does not match $ipaddr
          if ( scope.lookupvar( "ipaddress" ) =~ /^127.0.0.1$|[^\d|\.]+/ ) ||
             ( bootproto != "dhcp" && ( ip_fact_value != ip_param_value ))
          then
            result = "false"
          end
        end
        result
      -%>')

      # The sleep was added to make sure that the interface came back up if
      # it's coming up. If it took more than 10 seconds, something's probably
      # very wrong with your network.
      $command_string = $auto_restart ? {
        true    => "/sbin/ifdown $name ; /sbin/ifup $name && wait && sleep 10",
        default => '/bin/true',
      }

      $onlyif         = $onboot ? {
        /^(?i:(true|yes))/  => '/bin/true',
        default             => '/bin/false'
      }

      exec { "network_restart_$name":
        command     => $command_string,
        refreshonly => $refreshonly,
        onlyif      => $onlyif
      }
    }

    if $bonding {
      file { "/etc/modprobe.d/${name}.conf":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        content => template('network/modprobe_bond.erb'),
        notify  => Exec["activate_bonding_$name"]
      }

      exec { "activate_bonding_$name":
        command     => "/sbin/modprobe -r $name && /sbin/modprobe $name",
        refreshonly => true,
        notify      => Exec["network_restart_$name"]
      }
    }
  }

}

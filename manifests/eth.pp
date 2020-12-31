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
# FIXME: This does require that you include 'network::redhat' to get the network
# service defined.
#
# @param name
#   DEVICE is taken from this variable.
#
# @param auto_discover_mac
#   Determine whether or not the system should try and auto-discover a MAC
#   address for the interface specified.
#
# @param bonding
#   This variable does not translate into an init script option. If you set
#   this to true instead of false any hardware address auto-discovery will be
#   ignored. Otherwise, the interface will attempt to auto-discover the
#   interface. If you explicitly set hwaddr or macaddr, then this will be
#   ignored.
#
# @param arp
# @param bond_arp_interval
# @param bond_arp_ip_target
# @param bond_downdelay
# @param bond_lacp_rate
# @param bond_max_bonds
# @param bond_miimon
# @param bond_mode
# @param bond_primary
# @param bond_updelay
# @param bond_use_carrier
# @param bond_xmit_hash_policy
# @param bootproto
# @param bridge
# @param broadcast
# @param delay
#   If hosting VMs, set delay to 0.
# @param dhclient_ignore_gateway
#
# The following 3 options are passed as dhclientargs.
#
# @param dhclient_request_option_list
# @param dhclient_timeout
# @param dhclient_vendor_class_identifier
# @param dhcpclass
# @param dhcp_hostname
# @param dhcprelease
# @param dns1
# @param dns2
# @param ethtool_opts
# @param ensure
# @param reorder_hdr
# @param gateway
# @param hotplug
# @param hwaddr
#   If you set this, you have the following options:
#     1) Leave Blank -> Auto-detect (default)
#     2) Set to something with ':' -> Set to MAC address (if valid)
#     3) Set to anything else -> Leave unset and add a comment
#
# @param ipaddr
# @param ipv6_autoconf
# @param ipv6_control_radvd
# @param ipv6_mtu
# @param ipv6_privacy
# @param ipv6_radvd_pidfile
# @param ipv6_radvd_trigger_action
# @param ipv6_router
# @param ipv6addr
# @param ipv6addr_secondaries
# @param ipv6init
# @param ipv6to4_ipv4addr
# @param ipv6to4_mtu
# @param ipv6to4_relay
# @param ipv6to4_routing
# @param ipv6to4init
# @param isalias
# @param linkdelay
# @param macaddr
#     If you set this variable, it will override any setting for $hwaddr!
#
# @param master
# @param metric
# @param mtu
# @param net_type
# @param netmask
# @param network
#
# @param nm_controlled
#   **EXPERIMENTAL** feature to mark an interface as controlled by
#   NetworkManager. If set, the code attempts a best-effort case to enable the
#   interface and control it via the NetworkManager tools.
#
# @param nozeroconf
# @param onboot
# @param peerdns
# @param physdev
# @param persistent_dhclient
# @param slave
# @param srcaddr
# @param userctl
# @param vlan
# @param vlan_name_type
# @param window
# @param auto_restart
#   Restart the network if necessary due to a configuration change.
#
# @author https://github.com/simp/pupmod-simp-network/graphs/contributors
#
define network::eth (
  Optional[Boolean]                 $arp                              = undef,
  Boolean                           $auto_discover_mac                = true,
  Boolean                           $bonding                          = false,
  Optional[Integer]                 $bond_arp_interval                = undef,
  Optional[Simplib::IP]             $bond_arp_ip_target               = undef,
  Optional[Integer]                 $bond_downdelay                   = undef,
  Optional[Integer[0,1]]            $bond_lacp_rate                   = undef,
  Optional[Integer]                 $bond_max_bonds                   = undef,
  Optional[Integer]                 $bond_miimon                      = undef,
  Optional[Network::BondMode]       $bond_mode                        = undef,
  Optional[String]                  $bond_primary                     = undef,
  Optional[Integer]                 $bond_updelay                     = undef,
  Optional[Integer[0,1]]            $bond_use_carrier                 = undef,
  Optional[Network::TransmitPolicy] $bond_xmit_hash_policy            = undef,
  Network::Eth::BootProto           $bootproto                        = 'dhcp',
  Optional[String]                  $bridge                           = undef,
  Optional[Simplib::IP]             $broadcast                        = undef,
  Optional[Integer]                 $delay                            = undef,
  Optional[Boolean]                 $dhclient_ignore_gateway          = undef,
  Optional[Array[String]]           $dhclient_request_option_list     = undef,
  Integer                           $dhclient_timeout                 = 10080,
  Optional[String[1]]               $dhclient_vendor_class_identifier = undef,
  Optional[Simplib::Hostname]       $dhcp_hostname                    = undef,
  Optional[String[1]]               $dhcpclass                        = undef,
  Optional[String[1]]               $dhcprelease                      = undef,
  Optional[Simplib::Host]           $dns1                             = undef,
  Optional[Simplib::Host]           $dns2                             = undef,
  Optional[Array[String[1]]]        $ethtool_opts                     = undef,
  Enum['absent','present']          $ensure                           = 'present',
  Optional[Boolean]                 $reorder_hdr                      = undef,
  Optional[Simplib::IP]             $gateway                          = undef,
  Optional[Boolean]                 $hotplug                          = undef,
  Optional[Simplib::Macaddress]     $hwaddr                           = undef,
  Optional[Simplib::IP]             $ipaddr                           = undef,
  Optional[Boolean]                 $ipv6_autoconf                    = undef,
  Optional[Boolean]                 $ipv6_control_radvd               = undef,
  Optional[Integer]                 $ipv6_mtu                         = undef,
  String[1]                         $ipv6_privacy                     = 'rfc3041',
  Optional[String[1]]               $ipv6_radvd_pidfile               = undef,
  Optional[String[1]]               $ipv6_radvd_trigger_action        = undef,
  Optional[Boolean]                 $ipv6_router                      = undef,
  Optional[Simplib::IP::V6]         $ipv6addr                         = undef,
  Optional[Array[Simplib::IP::V6]]  $ipv6addr_secondaries             = undef,
  Optional[Boolean]                 $ipv6init                         = undef,
  Optional[String[1]]               $ipv6to4_ipv4addr                 = undef,
  Optional[Integer]                 $ipv6to4_mtu                      = undef,
  Optional[String[1]]               $ipv6to4_relay                    = undef,
  Optional[String[1]]               $ipv6to4_routing                  = undef,
  Optional[Boolean]                 $ipv6to4init                      = undef,
  Optional[Boolean]                 $isalias                          = undef,
  Optional[Integer[1]]              $linkdelay                        = undef,
  Optional[Simplib::Macaddress]     $macaddr                          = undef,
  Optional[String[1]]               $master                           = undef,
  Optional[String[1]]               $metric                           = undef,
  Optional[Integer[1]]              $mtu                              = undef,
  Optional[String[1]]               $net_type                         = undef,
  Optional[Simplib::IP]             $netmask                          = undef,
  Optional[Simplib::IP]             $network                          = undef,
  Boolean                           $nm_controlled                    = pick(fact('simplib__networkmanager.enabled'), false),
  Optional[String[1]]               $nozeroconf                       = undef,
  Optional[Boolean]                 $onboot                           = true,
  Optional[Boolean]                 $peerdns                          = undef,
  Optional[String[1]]               $physdev                          = undef,
  Optional[Boolean]                 $persistent_dhclient              = undef,
  Optional[Boolean]                 $slave                            = undef,
  Optional[Simplib::IP]             $srcaddr                          = undef,
  Optional[Boolean]                 $userctl                          = undef,
  Boolean                           $vlan                             = false,
  Optional[Network::VlanType]       $vlan_name_type                   = undef,
  Optional[Integer[1]]              $window                           = undef,
  Boolean                           $auto_restart                     = true
) {
  include 'network'

  if ($net_type == 'Bridge') or ($bridge =~ NotUndef) {
    if ($facts['os']['name'] in ['RedHat','CentOS','OracleLinux']) and ($facts['os']['release']['major'] < '8') {
      include 'network::eth::bridge_packages'
    }
  }

  if $ensure == 'absent' {
    exec { "/usr/sbin/ip link set ${name} down":
      onlyif    => "/sbin/ip link show up | /usr/bin/tr -d ' ' | /bin/grep '^[[:digit:]]' | /bin/cut -f2 -d':' | /bin/grep -q '^${name}$'",
      logoutput => 'on_failure',
    }

    file { "/etc/sysconfig/network-scripts/ifcfg-${name}":
      ensure => 'absent'
    }
  }
  else {
    file { "/etc/sysconfig/network-scripts/ifcfg-${name}":
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('network/eth.erb')
    }

    # NetworkManager needs to handle everything itself
    if $nm_controlled {
      include network::service::network_manager

      exec { "NetworkManager load connection ${name}":
        command     => "nmcli con load '/etc/sysconfig/network-scripts/ifcfg-${name}'",
        path        => '/bin',
        refreshonly => true,
        subscribe   => File["/etc/sysconfig/network-scripts/ifcfg-${name}"]
      }
    }
    else {
      include network::service::legacy

      File["/etc/sysconfig/network-scripts/ifcfg-${name}"] ~> Exec["network_restart_${name}"]
    }

    if ($net_type == 'Bridge') or ($bridge =~ NotUndef) or $bonding or ($slave =~ NotUndef) {
      exec { "network_restart_${name}":
        command     => '/bin/true',
        refreshonly => true,
        logoutput   => 'on_failure',
        notify      => Class['network::service']
      }

      if $nm_controlled {
        Exec["network_restart_${name}"] ~> Class['network::service::network_manager']
      }
      else {
        Exec["network_restart_${name}"] ~> Class['network::service::legacy']

        if ($net_type == 'Bridge') or ($bridge =~ NotUndef) {
          Class['network::eth::bridge_packages'] -> Exec["network_restart_${name}"]
        }
      }
    }
    else {
      # Refresh this interface if:
      #   - we don't have information about it
      #   - we have special knowledge that it needs to be reconfigured.
      # Otherwise, refresh it only when prodded by another resource change.
      #
      # NOTE: If the ipaddress fact is '127.0.0.1' or a non-ip (like 'FORCE'),
      # this class will *always* force a refresh.  This works around a fatal error
      # caused by the core fact 'ipaddress' and enables 'puppet apply' to
      # configure an offline system.
      $_safe_if_name = sprintf('ipaddress_%s', regsubst($name, '/\.|:/', '_'))
      if fact($_safe_if_name) {
        $_iface_addr = fact($_safe_if_name)
      }
      else {
        $_iface_addr = $facts.dig('networking', 'interfaces', $name, 'ip')
      }

      if $_iface_addr {
        if ($facts['ipaddress'] =~ /^127.0.0.1$|[^\d|\.]+/) or ( (!($bootproto in ['dhcp','bootp'])) and ($_iface_addr != $ipaddr )) {
          $_refreshonly = false
        }
      }
      else {
        $_refreshonly = false
      }

      unless defined('$_refreshonly') { $_refreshonly = true }

      # Only restart the interface you are managing
      # The sleep was added to make sure that the interface came back up if
      # it's coming up. If it took more than 10 seconds, something's probably
      # very wrong with your network.
      if $auto_restart {
        if $nm_controlled {
          $_command_string = "/bin/nmcli connection down ifname ${name}; /bin/nmcli connection up ifname ${name} && wait && sleep 10"
        }
        else {
          $_command_string = "/sbin/ifdown ${name}; /sbin/ifup ${name} && wait && sleep 10"
        }
      }
      else {
        $_command_string = '/bin/true'
      }

      $_onlyif = $onboot ? {
        true    => '/bin/true',
        default => '/bin/false'
      }

      exec { "network_restart_${name}":
        command     => $_command_string,
        refreshonly => $_refreshonly,
        onlyif      => $_onlyif,
        logoutput   => 'on_failure'
      }
    }

    if $bonding {
      file { "/etc/modprobe.d/${name}.conf":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        content => template('network/modprobe_bond.erb'),
        notify  => Exec["activate_bonding_${name}"]
      }

      exec { "activate_bonding_${name}":
        command     => "/sbin/modprobe -r ${name} && /sbin/modprobe ${name}",
        refreshonly => true,
        logoutput   => 'on_failure'
      }

      # NetworkManager needs to handle everything itself
      if $nm_controlled {
        Exec["activate_bonding_${name}"] ~> Class['network::service::network_manager']
      }
      else {
        Exec["activate_bonding_${name}"] ~> Exec["network_restart_${name}"]
      }
    }
  }
}

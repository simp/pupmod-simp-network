# == Class: network::global
#
# This sets up the global options in /etc/sysconfig/network
#
# See /usr/share/doc/initscripts-<version>/sysconfig.txt for details of
# each option.
#
# == Parameters
#
# [*gateway*]
# [*gatewaydev*]
# [*hostname*]
# [*ipv6_autoconf*]
# [*ipv6_autotunnel*]
# [*ipv6_defaultdev*]
# [*ipv6_defaultgw*]
# [*ipv6_router*]
# [*ipv6forwarding*]
# [*network*]
# [*networkdelay*]
# [*networking*]
# [*networking_ipv6*]
# [*nisdomain*]
# [*nozeroconf*]
# [*peerdns*]
# [*vlan*]
# [*auto_restart*]
#   Restart the network if necessary due to a configuration change.
#
# [*persistent_dhclient*]
#
class network::global (
  $gateway = '',
  $gatewaydev = '',
  $hostname = $fqdn,
  $ipv6_autoconf = '',
  $ipv6_autotunnel = '',
  $ipv6_defaultdev = '',
  $ipv6_defaultgw = '',
  $ipv6_router = '',
  $ipv6forwarding = 'no',
  $network = '',
  $networkdelay = '0',
  $networking = 'yes',
  $networking_ipv6 = 'yes',
  $nisdomain = '',
  $nozeroconf = '',
  $peerdns = 'no',
  $vlan = 'no',
  $auto_restart = true,
  $persistent_dhclient = ''
) {
  validate_bool($auto_restart)

  file { '/etc/sysconfig/network':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('network/global.erb'),
    notify  => Exec['global_network_restart']
  }

  $_command = $auto_restart ? {
    true    => '/sbin/service network restart',
    default => '/bin/true'
  }

  exec { 'global_network_restart':
    command     => $_command,
    refreshonly => true
  }
}

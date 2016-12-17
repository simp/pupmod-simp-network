# This sets up the global options in /etc/sysconfig/network
#
# See /usr/share/doc/initscripts-<version>/sysconfig.txt for details of
# each option.
#
# @param gateway
# @param gatewaydev
# @param hostname
# @param ipv6_autoconf
# @param ipv6_autotunnel
# @param ipv6_defaultdev
# @param ipv6_defaultgw
# @param ipv6_router
# @param ipv6forwarding
# @param network
# @param networkdelay
# @param networking
# @param networking_ipv6
# @param nisdomain
# @param nozeroconf
# @param peerdns
# @param vlan
# @param auto_restart Restart the network if necessary due to a configuration change.
# @param persistent_dhclient
#
class network::global (
  Optional[Simplib::IP] $gateway             = undef,
  Optional[String]      $gatewaydev          = undef,
  Simplib::Hostname     $hostname            = $facts['fqdn'],
  Optional[Boolean]     $ipv6_autoconf       = undef,
  Optional[Boolean]     $ipv6_autotunnel     = undef,
  Optional[String]      $ipv6_defaultdev     = undef,
  Optional[String]      $ipv6_defaultgw      = undef,
  Optional[Boolean]     $ipv6_router         = undef,
  Boolean               $ipv6forwarding      = false,
  Optional[Simplib::IP] $network             = undef,
  Optional[Integer]     $networkdelay        = 0,
  Optional[Boolean]     $networking          = true,
  Optional[Boolean]     $networking_ipv6     = true,
  Optional[String]      $nisdomain           = undef,
  Boolean               $nozeroconf          = false,
  Optional[Boolean]     $peerdns             = false,
  Boolean               $vlan                = false,
  Optional[Boolean]     $auto_restart        = true,
  Boolean               $persistent_dhclient = false
) {

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

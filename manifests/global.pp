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
# @author https://github.com/simp/pupmod-simp-network/graphs/contributors
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
  Optional[Boolean]     $ipv6forwarding      = undef,
  Optional[Simplib::IP] $network             = undef,
  Optional[Integer]     $networkdelay        = undef,
  Optional[Boolean]     $networking          = undef,
  Optional[Boolean]     $networking_ipv6     = undef,
  Optional[String]      $nisdomain           = undef,
  Optional[Boolean]     $nozeroconf          = undef,
  Optional[Boolean]     $peerdns             = undef,
  Optional[Boolean]     $vlan                = undef,
  Optional[Boolean]     $auto_restart        = $network::auto_restart,
  Optional[Boolean]     $persistent_dhclient = undef
) inherits network {

  file { '/etc/sysconfig/network':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('network/global.erb')
  }

  if $auto_restart {
    File['/etc/sysconfig/network'] ~> Class['network::service']
  }
}

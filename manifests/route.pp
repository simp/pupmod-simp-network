# Add a static route to an interface.
#
# See `/usr/share/doc/initscripts-*/sysconfig.txt` for details of
# each option.
#
# @example Defining a static route (Hiera)
#   eth0-1.1.1.1:
#     interface: eth0
#     next_hop: 8.8.8.8
#     cidr_netmask: 1.1.1.1/32
#     auto_restart: true # <- default
#
# @example Defining multiple routes for the same interface (Puppet code)
#   network::route{ 'eth1-first-static-route':
#     interface    => 'eth1',
#     cidr_netmask => "192.168.1.0/24',
#     next_hop     => '192.168.1.1,
#   }
#
#   network::route{ 'eth1-second-static-route':
#     interface    => 'eth1',
#     cidr_netmask => '192.168.3.0/24',
#     next_hop     => '192.168.3.1',
#   }
#
#
# @param interface
# @param cidr_netmask
# @param next_hop
# @param auto_restart
#   Restart the network if necessary due to a configuration change.
#
# @author https://github.com/simp/pupmod-simp-network/graphs/contributors
#
define network::route (
  String      $interface,
  String      $cidr_netmask,
  Simplib::IP $next_hop,
  Boolean     $auto_restart = true
) {

  simplib::assert_metadata($module_name)

  if ! defined(Concat["route_${interface}"]) {
    concat { "route_${interface}":
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      notify => Exec["route_restart_${name}"],
      path   => "/etc/sysconfig/network-scripts/route-${interface}"
    }
  }

  concat_fragment { "route_${interface}+${name}":
    content => "${cidr_netmask} via ${next_hop}\n",
    target  => "route_${interface}"
  }

  $_command = $auto_restart ? {
    true    => "/sbin/ifdown ${interface} && /sbin/ifup ${interface}; wait",
    default => '/bin/true'
  }

  exec { "route_restart_${name}":
    command     => $_command,
    refreshonly => true
  }
}

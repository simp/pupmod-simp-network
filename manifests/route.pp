# Add a static route to an interface.
#
# See /usr/share/doc/initscripts-<version>/sysconfig.txt for details of
# each option.
#
# Note: At this time multiple static routes can only be added by injecting
#       newlines into the cidr_netmask variable. See the following as an example:
#
#       cidr_netmask => "192.168.1.0/24 via 192.168.0.1\n192.168.2.0/24"
#
# @param interface
# @param cidr_netmask
# @param next_hop
# @param auto_restart
#   Restart the network if necessary due to a configuration change.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
define network::route (
  String      $interface,
  String      $cidr_netmask,
  Simplib::IP $next_hop,
  Boolean     $auto_restart = true
) {

  if ! defined(Concat["route_${interface}"]) {
    concat { "route_${interface}":
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      notify    => Exec["route_restart_${name}"],
      path      => "/etc/sysconfig/network-scripts/route-${interface}"
    }
  }

  concat_fragment { "route_${interface}+${name}":
    content => "${cidr_netmask} via ${next_hop}\n",
    target  => "route_${interface}"
  }

  $_command = $auto_restart ? {
    true    => "/sbin/ifdown ${name} && /sbin/ifup ${name}; wait",
    default => '/bin/true'
  }

  exec { "route_restart_${name}":
    command     => $_command,
    refreshonly => true
  }
}

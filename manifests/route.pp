# == Define: network::route
#
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
# == Parameters
#
# [*interface*]
# [*cidr_netmask*]
# [*next_hop*]
# [*auto_restart*]
#   Restart the network if necessary due to a configuration change.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
define network::route (
  $interface,
  $cidr_netmask,
  $next_hop,
  $auto_restart = true
) {
  validate_bool($auto_restart)

  file { "/etc/sysconfig/network-scripts/route-${interface}":
    ensure    => 'file',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    subscribe => Concat_build["route_${interface}"],
    notify    => Exec["route_restart_${name}"],
    audit     => content
  }

  if !defined(Concat_build["route_${interface}"]) {
    concat_build { "route_${interface}":
      target        => "/etc/sysconfig/network-scripts/route-${interface}",
      squeeze_blank => true
    }
  }

  concat_fragment { "route_${interface}+${name}":
    content => "${cidr_netmask} via ${next_hop}\n",
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

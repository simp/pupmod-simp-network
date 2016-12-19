# Manage network devices
#
# @param auto_restart
#   Restart the network if necessary due to a configuration change.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class network (
  Boolean $auto_restart = true
) {

  service { 'network':
    ensure    => 'running',
    enable    => true,
    restart   => '/usr/local/sbin/careful_network_restart.sh &',
    hasstatus => true,
    require   => File['/usr/local/sbin/careful_network_restart.sh']
  }

  $_content = $auto_restart ? {
    true    => '#!/bin/sh
while [ `/bin/ps h -fC puppet,puppetd | /bin/grep -ce "puppet\(d\| agent\)"` -gt 0 ]; do /bin/sleep 5; done; /sbin/service network restart
',
    default => '/bin/true'
  }

  file { '/usr/local/sbin/careful_network_restart.sh':
    ensure  => 'file',
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    content => $_content
  }
}

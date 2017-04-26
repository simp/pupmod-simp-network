# Manage network devices
#
# @param auto_restart
#   Restart the network if necessary due to a configuration change.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class network (
  Boolean $auto_restart   = true,
  String  $package_ensure = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' })
) {

  service { 'network':
    ensure    => 'running',
    enable    => true,
    restart   => '/usr/local/sbin/careful_network_restart.sh &',
    hasstatus => true,
    require   => File['/usr/local/sbin/careful_network_restart.sh']
  }

  # Only works if Puppet is being run from cron (default in SIMP)
  # Restart if `puppet apply` or `puppet agent` process is found
  $_content = $auto_restart ? {
    true    => '#!/bin/sh
while [ `/bin/ps h -fC puppet | /bin/grep -ce "puppet \(agent\|apply\)"` -gt 0 ]; do /bin/sleep 5; done; /sbin/service network restart
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

  package { ['bind-utils', 'bridge-utils']:
    ensure => $package_ensure,
  }
}

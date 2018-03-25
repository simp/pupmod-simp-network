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

  simplib::assert_metadata($module_name)

  service { 'network':
    ensure     => 'running',
    enable     => true,
    restart    => '/usr/local/sbin/careful_network_restart.sh &',
    hasstatus  => true,
    hasrestart => false,
    require    => File['/usr/local/sbin/careful_network_restart.sh']
  }

  $_restart_cmd = @(CMD)
    #!/bin/sh
    while [ `ps h -fC puppet | grep -ce "puppet \(agent\|apply\)"` -gt 0 ]; do
      sleep 5
    done

    # The input redirection here is required for this to work in Puppet 5
    service network restart > /dev/null 2>&1
    | CMD

  # Only works if Puppet is being run from cron (default in SIMP)
  # Restart if `puppet apply` or `puppet agent` process is found
  $_content = $auto_restart ? {
    true    => $_restart_cmd,
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

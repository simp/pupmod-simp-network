# Restarts the network using a wrapper script that delays execution until
# *after* the Puppet agent run is finished.
#
# This ensures that network changes aren't applied during a Puppet agent run
# and potentially disrupt its other configurations and report (unless
# explicitly configured otherwise in specific `network::eth` declarations).
#
# @author https://github.com/simp/pupmod-simp-network/graphs/contributors
#
class network::service::legacy {

  assert_private()

  if $facts['service_provider'] == 'systemd' {
    $_net_restart = 'systemctl restart network'
  } else {
    $_net_restart = 'service network restart'
  }

  $_restart_cmd = @("CMD")
    #!/bin/sh
    while [ `ps h -fC puppet | grep -ce "puppet \\(agent\\|apply\\)"` -gt 0 ]; do
      sleep 5
    done

    # The input redirection here is required for this to work in Puppet 5
    ${_net_restart} > /dev/null 2>&1
    | CMD

  file { '/usr/local/sbin/careful_network_restart.sh':
    ensure  => 'file',
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    content => $_restart_cmd
  }

  service { 'network':
    ensure     => 'running',
    enable     => true,
    restart    => '/usr/local/sbin/careful_network_restart.sh &',
    hasstatus  => true,
    hasrestart => false,
    require    => File['/usr/local/sbin/careful_network_restart.sh']
  }
}

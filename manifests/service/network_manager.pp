# Restarts the network using a wrapper script that delays execution until
# *after* the Puppet agent run is finished.
#
# This ensures that network changes aren't applied during a Puppet agent run
# and potentially disrupt its other configurations and report (unless
# explicitly configured otherwise in specific `network::eth` declarations).
#
# @param puppet_agent_installed
#   If puppet agent is running as service set this to true
#
# @author https://github.com/simp/pupmod-simp-network/graphs/contributors
#
class network::service::network_manager (
  Boolean $puppet_agent_installed = false
) {

  assert_private()

  # By design, NetworkManager doesn't need to restart the network in order to
  # modify/add/remove connections.  However, by the time the delayed wrapper
  # script runs, the simplest solution is to just reload all connections'
  # configurations.
  #
  # Cycling `nmcli networking` on and off is a hack that appears to be
  # *required*, at least to bring up a DHCP-enabled bridge using an
  # already-active connection (as we discovered in our acceptance tests).
  #
  # There might be a less disruptive way to to do this, but it would probably
  # involve a lot of refactoring and a building up a (probably fragile) chain
  # of delayed connection-specific nmcli commands.
  $_net_restart = 'nmcli con reload && nmcli networking off; sleep 1; nmcli networking on'

  if $puppet_agent_installed {
    $num_puppet_processes = 1
  } else {
    $num_puppet_processes = 0
  }

  $_restart_cmd = @("CMD")
    #!/bin/sh
    while [ `ps h -fC puppet | grep -ce "puppet \\(agent\\|apply\\)"` -gt ${num_puppet_processes} ]; do
      sleep 5
    done

    # The input redirection here is required for this to work in Puppet 5
    ${_net_restart} > /dev/null 2>&1
    | CMD

  file { '/usr/local/sbin/careful_network_manager_restart.sh':
    ensure  => 'file',
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    content => $_restart_cmd
  }

  service { 'NetworkManager':
    ensure     => 'running',
    enable     => true,
    restart    => '/usr/local/sbin/careful_network_manager_restart.sh &',
    hasstatus  => true,
    hasrestart => false,
    require    => File['/usr/local/sbin/careful_network_manager_restart.sh']
  }
}

# Wrapper around the network service that does not disconnect a puppet agent
# run.
#
# @author https://github.com/simp/pupmod-simp-network/graphs/contributors
#
class network::service {

  assert_private()

  if fact('simplib_networkmanager.enabled') {
    $_service_name = 'NetworkManager'

    # Attempted various permutations of these commands to get the acceptance
    # test to work. This may be specific to bridging, but there really isn't
    # any way to tell.
    #
    # Just restarting the NetworkManager service resulted in the ethernet
    # device having the IP address and the Bridge hanging.
    #
    # Just restarting the networking missed picking up some of the new files.
    #
    # Restarting both, in this order, picked everything up properly.
    $_net_restart = 'service NetworkManager restart && nmcli networking off; sleep 1; nmcli networking on'
  }
  else {
    $_service_name = 'network'
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

  service { $_service_name:
    ensure     => 'running',
    enable     => true,
    restart    => '/usr/local/sbin/careful_network_restart.sh &',
    hasstatus  => true,
    hasrestart => false,
    require    => File['/usr/local/sbin/careful_network_restart.sh']
  }
}

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

  include 'network::service'
}

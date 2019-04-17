# Contains all supported network management services
#
# @param manage_legacy
#   Enable management of the legacy 'network' service
#
# @param manage_network_manager
#   Enable management of the NetworkManager service
#
#   * Defaults to the running active state of NetworkManager on the target system
#
# @author https://github.com/simp/pupmod-simp-network/graphs/contributors
#
class network::service (
  Boolean $manage_legacy          = true,
  Boolean $manage_network_manager = pick(fact('simplib__networkmanager.enabled'), false)
){

  assert_private()

  if $manage_legacy {
    contain network::service::legacy
  }

  if $manage_network_manager {
    contain network::service::network_manager
  }
}

# Include the required bridge packages
#
# @param package_ensure
#   The state to which the required packages should be set
#
class network::eth::bridge_packages (
  Simplib::PackageEnsure $package_ensure = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' })
) {
  assert_private()

  ensure_packages('bridge-utils', {'ensure' => $package_ensure })
}

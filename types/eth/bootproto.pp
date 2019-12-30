# @summary Valid ethernet boot protocols
type Network::Eth::BootProto = Enum[
  'none',
  'static',
  'bootp',
  'dhcp'
]

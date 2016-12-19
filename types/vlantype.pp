# taken from http://lxr.free-electrons.com/source/net/8021q/vlan.c?v=2.6.32#L310
type Network::VlanType = Enum[
  'VLAN_NAME_TYPE_RAW_PLUS_VID',
  'VLAN_NAME_TYPE_PLUS_VID_NO_PAD',
  'VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD',
  'VLAN_NAME_TYPE_PLUS_VID'
]

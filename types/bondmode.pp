# @summary Valid bond modes for network interfaces
type Network::BondMode = Variant[
  Integer[0,6],
  Enum[
    'balance-rr',
    'active-backup',
    'balance-xor',
    'broadcast',
    '802.3ad',
    'balance-tlb',
    'balance-alb'
  ]
]

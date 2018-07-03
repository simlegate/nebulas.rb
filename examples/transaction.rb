require "bundler/setup"
require "nebulas"

account = Nebulas::Account.new

tx = Nebulas::Transaction.new(
      chain_id: 1001, 
      from: account, 
      to: 'n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC', 
      value: 10000,
      nonce: 100001010,
      payload_type: 'call',
      payload: Nebulas::Tx::DeployPayload.new('var i=0', 'js'),
      gas_price: 1000,
      gas_limit: 1100)

p tx

p 'get proto binary'
p tx.to_proto

p 'get proto string'
p tx.to_proto_str

p 'restore from proto string'
tx1 = Nebulas::Transaction.from_base64_proto(tx.to_proto_str)
p tx1

require "bundler/setup"
require "nebulas"

p "*"*100
p "connecting to test network of nebulas..........."
p "*"*100

chain = Nebulas::Blockchain.new(Nebulas::HttpClient.new('test'))
account = Nebulas::Account.new

p "Return the state of the neb"
p chain.neb_state

p "Return the state of the account"
p chain.account_state("n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC")

p "Return the latest irreversible block"
p chain.latest_irreversible_block

p "Call a smart contract function"
p chain.call({from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", 
            to: "n1mL2WCZyRi1oELEugfCZoNAW3dt8QpHtJw",
            value: "0", 
            nonce: "3", 
            gasPrice: "1000000", 
            gasLimit: "2000000",
            contract: {function: "transferValue", args: "[500]"}})

p "Submit the signed transaction"
tx = Nebulas::Transaction.new(
      chain_id: 1001, 
      from: account, 
      to: 'n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC',
      value: 10,
      nonce: 12,
      payload_type: 'call',
      payload: Nebulas::Tx::DeployPayload.new('var i=0', 'js'))
p chain.send_raw_transaction(tx.to_proto_str)

p "Get block header info by the block hash."
p chain.block_by_hash('03dd3bcb560c51977e31840dc82411335a9eae3310c7403b44ae389fba2d9c6d')

p "Get block header info by the block hash."
p chain.block_by_height('525044')

p "Get transactionReceipt info by tansaction hash. "
p chain.transaction_receipt('03dd3bcb560c51977e31840dc82411335a9eae3310c7403b44ae389fba2d9c6d')

p "Get transactionReceipt info by contract address. "
p chain.transaction_by_contract("n1mL2WCZyRi1oELEugfCZoNAW3dt8QpHtJw")

p "Return the subscribed events of transaction & block. "
p chain.subscribe("chain.revertBlock")

p "Return current gasPrice."
p chain.gas_price

p "Return the estimate gas of transaction."
p chain.estimate_gas({from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", 
            to: "n1mL2WCZyRi1oELEugfCZoNAW3dt8QpHtJw",
            value: "0", 
            nonce: "3", 
            gasPrice: "1000000", 
            gasLimit: "2000000",
            contract: {function: "transferValue", args: "[500]"}})

p "Return the events list of transaction."
p chain.events_by_hash("03dd3bcb560c51977e31840dc82411335a9eae3310c7403b44ae389fba2d9c6d")

p "GetDynasty get dpos dynasty."
p chain.dynasty(525044)
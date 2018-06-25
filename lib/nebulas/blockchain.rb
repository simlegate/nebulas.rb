module Nebulas
  class Blockchain

    attr_reader :client

    def initialize client=nil
      if client.instance_of? HttpClient
        @client = client
      else
        @client = HttpClient.new('main')
      end
    end

    # Return the state of the neb

    # @example
    #   account.neb_state

    def neb_state
      client.get('/user/nebstate')
    end

    # Return the state of the account. Balance and nonce of the given address will be returned.
    #
    # @param [String] address Hex string of the account addresss
    # @param [Integer] height block account state with height. If not specified, use 0 as tail heigh
    # 
    # @example
    #   account.account_state("n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC", 2345)

    def account_state address, height=0
      client.post('/user/accountstate', { address: address, height: height })
    end

    # Return the latest irreversible block
    #
    # @example
    #   account.latest_irreversible_block

    def latest_irreversible_block
      client.get('/user/lib')
    end

    # Call a smart contract function
    # The smart contract must have been submited
    # Method calls are run only on the current node, not broadcast
    #
    # *Parameters from, to, value, nonce, gasPrice and gasLimit are required.*
    # *If the transaction is to send contract, you must specify the contract.*
    # 
    # @param [Hash] options
    # @option options [String] from Hex string of the account addresss
    # @option options [String] to Hex string of the account addresss.The value of to is a contract address.
    # @option options [String] value Amount of value sending with this transaction. The unit is Wei (10^-18 NAS).
    # @option options [String] nonce Transaction nonce.
    # @option options [String] gas_price gasPrice sending with this transaction.
    # @option options [String] gas_limit gasLimit sending with this transaction.
    # @option options [String] type transaction payload type. 
    #   If the type is specified, the transaction type is determined and the corresponding parameter needs to be passed in, otherwise the transaction type is determined according to the contract and binary data. 
    #   Currently support +binary+, +deploy+ and +call+
    # @option options [Hash] contract transaction contract object for call smart contract
    #   * :source (String) contract source code for deploy contract.
    #   * :sourceType (String) contract source type for deploy contract. Currently support +js+ and +ts+
    #   * :function (String) the contract call function for call contarct function.
    #   * :args (String)  the params of contract. The args content is JSON string of parameters array.
    # @option options [String] binary Transaction nonce.
    #
    # @example
    #   account.call {from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", 
    #                 to: "n1mL2WCZyRi1oELEugfCZoNAW3dt8QpHtJw",
    #                 value: "0", nonce: "3", 
    #                 gasPrice: "1000000", 
    #                 gasLimit: "2000000",
    #                 contract: {function: "transferValue", args: "[500]"}}

    def call options
      client.post('/user/call', options)
    end

    # Submit the signed transaction
    #
    # @param [String] data Signed data of transaction
    #
    # @example
    #   account.send_raw_transaction("CiCrHtxyyIJks2/RErvBBA862D6i........")

    def send_raw_transaction data
      client.post('/user/rawtransaction', {data: data})
    end

    # Get block header info by the block hash.
    #
    # @param [String] hash Hex string of transaction hash.
    # @param [Boolean] full If true it returns the full transaction objects, if false only the hashes of the transactions.
    #
    # @example
    #   account.block_by_hash("00000658397a90df6459b8e........")

    def block_by_hash hash, full=true
      client.post('/user/getBlockByHash', {hash: hash, full_fill_transaction: full})
    end

    # Get block header info by the block height.
    #
    # @param [Integer] height Height of transaction hash.
    # @param [Boolean] full If true it returns the full transaction objects, if false only the hashes of the transactions.
    #
    # @example
    #   account.block_by_height(256)

    def block_by_height height, full=true
      client.post('/user/getBlockByHeight', {height: height, full_fill_transaction: full})
    end

    # Get transactionReceipt info by tansaction hash. 
    # If the transaction not submit or only submit and not packaged on chain, it will reurn not found error.
    #
    # @param [String] hash Hex string of transaction hash.
    # 
    # @example
    #   account.transaction_receipt("cda54445ffccf4ea17f043e86e54be11b002053f9edbe30ae1fbc0437c2b6a73")

    def transaction_receipt hash
      client.post('/user/getTransactionReceipt', {hash: hash})
    end

    # Get transactionReceipt info by contract address. 
    # If contract not exists or packaged on chain, a not found error will be returned.
    #
    # @param [String] address Hex string of contract account address.
    #
    # @example
    #   account.transaction_by_contract("n1sqDHGjYtX6rMqFoq5Tow3s3LqF4ZxBvE3")

    def transaction_by_contract address
      client.post('/user/getTransactionByContract', { address: address })
    end

    # Return the subscribed events of transaction & block. 
    # The request is a keep-alive connection.
    # 
    # @param [Array<String>] topics repeated event topic name
    #   * _chain.pendingTransaction_ The topic of pending a transaction in transaction_pool.
    #   * _chain.latestIrreversibleBlock_ The topic of updating latest irreversible block.
    #   * _chain.transactionResult_ The topic of executing & submitting tx.
    #   * _chain.newTailBlock_ The topic of setting new tail block.
    #   * _chain.revertBlock_ The topic of reverting block.
    #
    # @example
    #   account.subscribe(["chain.revertBlock", "chain.pendingTransaction"])
    #   account.subscribe("chain.revertBlock")

    def subscribe topics
      client.post('/user/subscribe', { topics: Array(topics) })
    end

    # Return current gasPrice.
    #
    # @example
    #   account.gas_price

    def gas_price
      client.get('/user/getGasPrice')
    end

    # Return the estimate gas of transaction.
    #
    # The parameters of the EstimateGas method is the same as the *Call* parameters.
    #
    # @see #call 
    
    def estimate_gas options
      client.post('/user/estimateGas', options)
    end

    # Return the events list of transaction.
    #
    # @param [String] hash Hex string of transaction hash.
    #
    # @example
    #   account.events_by_hash("ec239d532249f84f158ef8ec9262e1d3d439709ebf4dd5f7c1036b26c6fe8073")

    def events_by_hash hash
      client.post('/user/getEventsByHash', {hash: hash})
    end

    # GetDynasty get dpos dynasty.
    #
    # @param [Integer] height block height
    #
    # @example
    #   account.dynasty(1)

    def dynasty height
      client.post('/user/dynasty', {height: height})
    end
  end
end

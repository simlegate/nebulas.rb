module Nebulas
  class Admin

    attr_reader :client

    def initialize client=nil
      if client.instance_of? HttpClient
        @client = client
      else
        @client = HttpClient.new
      end
    end

    # Return the p2p node info.
    #
    # @example
    #   admin.node_info

    def node_info
      client.get('/admin/nodeinfo')
    end

    # Return account list.
    #
    # @example
    #   admin.accounts

    def accounts
      client.get('/admin/accounts')
    end

    # create a new account with passphrase.
    # 
    # @param [String] passphrase New account passphrase.
    #
    # @example
    #   admin.create_account('123456789')

    def create_account passphrase
      client.post('/admin/accounts/new', { passphrase: passphrase })
    end

    # unlock account with passphrase. After the default unlock time, the account will be locked.
    #
    # @param [String] address UnLock account address.
    # @param [String] passphrase UnLock account passphrase.
    # @param [Integer] duration Unlock accout duration. The unit is ns (10e-9 s).
    #
    # @example
    #   admin.unlock_account('n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3', "123456789", 1000000)

    def unlock_account address, passphrase, duration
      client.post('/admin/accounts/new', {address: address, passphrase: passphrase, duration: duration})
    end

    # lock account.
    # 
    # @param [String] address Lock account address.
    #
    # @example
    #   admin.lock_account('n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3')

    def lock_account address
      client.post('/admin/accounts/new', { address: address })
    end

    # sign transaction. The transaction's from addrees must be unlocked before sign call.
    #
    # @param [String] transaction this is the same as the *Blockchain*#*call* parameters.
    # @see Blockchain#call
    # @param [String] passphrase from account passphrase
    #
    # @example
    #   admin.sign_tx_with_pwd({from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3".....}, "123456789")

    def sign_tx_with_pwd transaction, passphrase
      client.post('/admin/sign', { transaction: transaction, passphrase: passphrase })
    end

    # send transaction with passphrase.
    #
    # @param [String] transaction this is the same as the *Blockchain*#*call* parameters.
    # @see Blockchain#call
    # @param [String] passphrase from account passphrase
    #
    # @example
    #   admin.send_tx_with_pwd({from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3".....}, "123456789")

    def send_tx_with_pwd transaction, passphrase
      client.post('/admin/transactionWithPassphrase', { transaction: transaction, passphrase: passphrase })
    end

    # Send the transaction. 
    # 
    # The parameters of the this method is the same as the *Call* parameters.
    #
    # @see Blockchain#call 

    def send_transaction options
      client.post('/admin/transaction', options)
    end

    # sign the hash of a message.
    #
    # @param [String] address Sign address
    # @param [String] hash A sha3256 hash of the message, base64 encoded.
    #
    # @example
    #   admin.sign_hash("n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", "W+rOKNqs/tlvz02ez77yIYMCOr2EubpuNh5LvmwceI0=")

    def sign_hash address, hash
      client.post('/admin/sign/hash', {address: address, hash: hash, alg: 1})
    end

    # starts pprof
    #
    # @param listen the address to listen
    # 
    # @example
    #   admin.start_pprof("0.0.0.0:1234")

    def start_pprof listen
      client.post('/admin/pprof', {listen: listen})
    end

    # return the config current neb is using
    #
    # @example
    #   admin.config

    def config
      client.get('/admin/getConfig')
    end
  end
end

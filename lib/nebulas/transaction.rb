require 'base64'

module Nebulas
  class Transaction

    MAX_GAS_PRICE = 1_000_000_000_000

    DF_GAS_PRICE = 1_000_000

    DF_GAS_LIMIT = 20_000

    MAX_GAS = 50_000_000_000

    MAX_PAYLOAD_LEN = 1024 * 1024

    MAX_BIN_PAYLOAD_LEN = 64

    SECP256K1 = 1

    attr_accessor :chain_id, 
                  :from, 
                  :to, 
                  :value, 
                  :nonce, 
                  :payload_type,
                  :payload,
                  :gas_price,
                  :gas_limit,
                  :timestamp,
                  :alg

    attr_accessor :hash, :sign, :data

    def initialize options
      @chain_id     = options[:chain_id]
      @from         = options[:from]
      @to           = options[:to]
      @value        = options[:value]
      @nonce        = options[:nonce]
      @payload_type = options[:payload_type]
      @payload      = options[:payload]
      @gas_price    = options[:gas_price] || DF_GAS_PRICE
      @gas_limit    = options[:gas_limit] || DF_GAS_LIMIT

      @timestamp    = options[:timestamp] || Time.now.to_i
      @data = Corepb::Data.new(payload_type: @payload_type, payload: @payload.to_json)
    end

    def hash_tx
      @hash = Utils::Crypto.digest_with_sha3(
                Utils::BinUtil.from_str(@from.addr_str) +
                Utils::BinUtil.from_str(@to) +
                Utils::BinUtil.from_int(@value) +
                Utils::BinUtil.from_int(@nonce) +
                data_bin +
                Utils::BinUtil.from_int(@chain_id) +
                Utils::BinUtil.from_int(@gas_price) +
                Utils::BinUtil.from_int(@gas_limit))
    end

    def sign_tx
      @hash ||= hash_tx
      @sign = @from.sign_to_bin(@hash)
    end

    def self.from_base64_proto proto
      self.from_proto(Base64.decode64(proto))
    end

    def self.from_proto proto
      dtx = Corepb::Transaction.decode(proto)
      tx = self.new(
        from: Address.new(dtx.from),
        to: Utils::Crypto.base58encode(dtx.to),
        nonce: dtx.nonce,
        timestamp: dtx.timestamp,
        gas_price: Utils::BinUtil.to_int(dtx.gas_price),
        gas_limit: Utils::BinUtil.to_int(dtx.gas_limit),
        value: Utils::BinUtil.to_int(dtx.value),
        payload_type: dtx.data.payload_type,
        payload: parse_payload(dtx.data),
        chain_id: dtx.chain_id)
      tx.hash = dtx.to_hash[:hash]
      tx.sign = dtx.sign
      tx.alg = dtx.alg
      tx.data = dtx.data
      tx
    end

    def to_proto
      @sign ||= sign_tx
      tx = Corepb::Transaction.new(
        hash: @hash,
        from: from_addr.addr_bin,
        to: Address.from_addr(@to).addr_bin,
        value: Utils::BinUtil.from_int_with_fixed_len(@value, 16),
        nonce: @nonce,
        timestamp: @timestamp,
        data: @data,
        chain_id: @chain_id,
        gas_price: Utils::BinUtil.from_int_with_fixed_len(@gas_price, 16),
        gas_limit: Utils::BinUtil.from_int_with_fixed_len(@gas_limit, 16),
        alg: SECP256K1,
        sign: @sign)
      tx.to_proto
    end

    def to_proto_str
      Base64.strict_encode64(self.to_proto)
    end

    private
    def from_addr
      if @from.instance_of? Account
        @from.address
      elsif @from.instance_of? Address
        @from
      else
        raise 'Invalid from object'
      end
    end

    def data_bin
      @data_bin ||= Corepb::Data.encode(@data)
    end

    def self.parse_payload data
      case data.payload_type
      when 'binary'
        Tx::BinaryPayload.new(data.payload)
      when 'deploy'
        Tx::DeployPayload.from_json(data.payload)
      when 'call'
        Tx::CallPayload.from_json(data.payload)
      else
        raise 'Invalid Payload Type'
      end
    end
  end
end
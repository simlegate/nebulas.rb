require 'openssl'

module Nebulas
  class Account

    attr_reader :private_key, :public_key, :address, :ec

    def initialize private_key=nil
      build_ec private_key
      @private_key = ec.private_key
      @public_key = ec.public_key
      @address = Address.from_public_key(@public_key)
    end

    # sign content with ECDSA
    # 
    # @param [String] content plain text
    #
    # @return [String] hex string
    #
    # @example
    #   account.sign "password"

    def sign content
      Utils::BinUtil.to_hex(sign_to_bin(content))
    end

    def sign_to_bin content
      @ec.dsa_sign_asn1(content)
    end

    # verify signature with ECDSA
    #
    # @param [String] content plain text
    # @param [String] sign hex string
    #
    # @return [Boolean]
    #
    # @example
    #   account.verify "password", "3046022100936bbdf53d78....."

    def verify content, sign
    # raise OpenSSL::PKey::ECError(ECDSA_verify: nested asn1 error) when sign is wrong
      @ec.dsa_verify_asn1 content, Utils::BinUtil.from_hex(sign)
    rescue
      false
    end

    def private_key_str
      private_key.to_s(16).downcase
    end

    def pubilc_key_str
      public_key.to_bn.to_s(16).downcase
    end

    def addr_str
      address.addr
    end

    # generate keystore
    #
    # @param [String] password encrypt the keystore
    #
    # @return [Hash]
    #
    # @example
    #   account.keystore "123456789"

    def keystore password
      Utils::Keystore.generate(private_key_str, password)
    end

    # generate a account from keystore
    #
    # @param [Hash] keystore
    # @param [String] password decrypt the keystore
    #
    # @return [Account]
    #
    # @example
    #   account.restore {id: '..', address: '...', version: 3}, '123456789'
    
    def self.from_keystore keystore, password
      Utils::Keystore.restore(keystore, password)
    end

    private
    def build_ec private_key
      if private_key
        @ec = Utils::Crypto.ec_from_private(private_key)
      else
        @ec = Utils::Crypto.random_ec
      end
    end
  end
end

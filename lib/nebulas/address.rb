require 'base58'

module Nebulas
  class Address
  	LENGTH = 35
    BYTES_LENGTH = 26
    PREFIX = 'n'
    NORMAL_TYPE = 87
    CONTRACT_TYPE = 88
    PADDING_CODE = 25

    attr_reader :addr_bin

    def initialize addr_bin
      @addr_bin = addr_bin
    end

    def addr
      Utils::Crypto.base58encode(self.addr_bin)
    end

    # validate if this address is valid
    #
    # @param [String] address
    #
    # example
    #   Nebulas::Address.valid?("n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC")

    def self.valid? address
    	return false if address.length != LENGTH
      return false if !address.start_with?(PREFIX)
      begin
        addr = Utils::Crypto.base58decode(address)
      rescue
        return false
      end
      return false if addr.length != BYTES_LENGTH
      content = addr[0...(BYTES_LENGTH-4)]
      checksum = addr[(BYTES_LENGTH-4)..-1]
      checksum == Utils::Crypto.digest_with_sha3(content)[0...4]
    end

    def self.from_addr addr_str
      if self.valid? addr_str
        self.new(Utils::Crypto.base58decode(addr_str))
      else
        raise 'Invalid Address'
      end
    end

    def self.from_public_key(public_key)
      if public_key.instance_of? OpenSSL::PKey::EC::Point
        public_key = public_key.to_bn.to_s(16)
      end
      content = Utils::Crypto.digest_with_sha3(Utils::BinUtil.from_hex(public_key))
      content = Utils::Crypto.digest_with_rmd160(content)
      content = [PADDING_CODE, NORMAL_TYPE] + content.bytes
      checksum = Utils::Crypto.digest_with_sha3(content.pack("c*")).bytes[0...4]
      self.new((content + checksum).pack("c*"))
    end
  end
end
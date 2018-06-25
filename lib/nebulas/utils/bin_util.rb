module Nebulas
  module Utils
    module BinUtil
      def self.to_hex bin
        bin.unpack('H*').first
      end

      def self.from_hex hex
      	hex.scan(/../).map { |x| x.hex.chr }.join
      end

      def self.from_str str
        Array(str).pack("H*")
      end
    end
  end
end
module Nebulas
  module Utils
    module BinUtil
      def self.to_hex bin
        bin.unpack('H*').first
      end

      def self.to_int bin
        # self.to_hex(bin).to_i(16)
        bin.bytes.inject {|a, b| (a << 8) + b }
      end

      def self.from_hex hex
      	hex.scan(/../).map { |x| x.hex.chr }.join
      end

      def self.from_int number
        [number].pack("Q>")
      end

      def self.from_str str
        Array(str).pack("H*")
      end

      def self.from_int_with_fixed_len number, digit
        bin = [number].pack("Q>")
        pad_len = digit - bin.bytesize
        if pad_len > 0
          Array.new(pad_len, 0).pack("Q") + bin
        else
          bin
        end
      end
    end
  end
end
module Nebulas
  module Utils
    module HashUtil
      def self.symbolize_keys hash
        Hash[hash.map{|k,v| v.is_a?(Hash) ? [k.to_sym, symbolize_keys(v)] : [k.to_sym, v] }]
      end
    end
  end
end
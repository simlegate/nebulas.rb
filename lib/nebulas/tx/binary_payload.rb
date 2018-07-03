module Nebulas
  module Tx
    class BinaryPayload

      attr_reader :data

      def initialize data
        @data = data
      end

      def to_json
        @data
      end
    end
  end
end
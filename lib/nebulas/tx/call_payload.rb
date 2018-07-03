module Nebulas
  module Tx
    class CallPayload

      attr_reader :function, :args

      def initialize function, args
        @function = function
        @args = args
      end

      def self.from_json json
        attr = JSON.parse(json)
        self.new(attr['Function'], attr['Args'])
      end

      def to_json
        { Function: @function, Args: @args }.to_json
      end
    end
  end
end
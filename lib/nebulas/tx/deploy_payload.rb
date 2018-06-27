module Nebulas
  module Tx
    class DeployPayload

      attr_reader :source, :source_type

      JS_SOURCE_TYPE = 'js'

      TS_SOURCE_TYPE = 'ts'      

      def initialize source, source_type
        @source = source
        @source_type = source_type
        # if ![TS_SOURCE_TYPE, JS_SOURCE_TYPE].include?(source_type)
        #   raise 'Invalid source type of deploy payload'
        # end
      end

      def bytes
        Utils::BinUtil.from_str(self.to_json)
      end

      def to_json
        { SourceType: @source_type, Source: @source }.to_json
      end

      def self.from_json json
        attr = JSON.parse(json)
        self.new(attr['Source'], attr['SourceType'])
      end
    end
  end
end
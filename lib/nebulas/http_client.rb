require 'faraday'
require 'json'

module Nebulas
  class HttpClient
    VERSION = 'v1'

    MAIN_NET = 'https://mainnet.nebulas.io'

    TEST_NET = 'https://testnet.nebulas.io'

    attr_reader :host

    def initialize mode=nil, options={}
      case mode.to_s
      when 'main'
        @host = MAIN_NET
      when 'test'
        @host = TEST_NET
      when 'custom'
        @host = options[:uri]
      else
        @host = 'http://localhost:8685'
      end 
    end

    def get uri
      parse_body(Faraday.get(build_url(uri)))
    end

    def post uri, body
      parse_body(Faraday.post(build_url(uri), body.to_json))
    end

    private
    def build_url uri
      "#{host}/#{VERSION}#{uri}"
    end

    def parse_body res
      JSON.parse(res.body)['result']
    end
  end
end

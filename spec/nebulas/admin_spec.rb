RSpec.describe Nebulas::Admin do
  describe "initialize" do
    it "connect to mainnet by default" do
      chain = Nebulas::Admin.new
      expect(chain.client.host).to eq('http://localhost:8685')
    end

    it "can specify http client" do
      chain = Nebulas::Admin.new(Nebulas::HttpClient.new(:test))
      expect(chain.client.host).to eq(Nebulas::HttpClient::TEST_NET)
    end
  end
end

RSpec.describe Nebulas::Blockchain do
  describe "initialize" do
    it "connect mainnet by default" do
      chain = Nebulas::Blockchain.new
      expect(chain.client.host).to eq(Nebulas::HttpClient::MAIN_NET)
    end

    it "can specify http client" do
      chain = Nebulas::Blockchain.new(Nebulas::HttpClient.new(:test))
      expect(chain.client.host).to eq(Nebulas::HttpClient::TEST_NET)
    end
  end
end

require 'base64'

RSpec.describe Nebulas::Transaction do
  let(:account) {
    account = Nebulas::Account.new
  }
  let(:transaction){
    Nebulas::Transaction.new(
      chain_id: 1001, 
      from: account, 
      to: 'n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC', 
      value: 10000,
      nonce: 100001010,
      payload_type: 'deploy',
      payload: Nebulas::Tx::DeployPayload.new('var i=0', 'js'),
      gas_price: 1000,
      gas_limit: 1100)
  }
  describe "#hash_tx" do
    it "get binary string" do
      expect(binary_str?(transaction.hash_tx)).to be true
    end
  end

  describe "#sign_tx" do
    it "get binary string" do
      transaction.sign_tx
      expect(binary_str?(transaction.sign)).to be true
    end
  end

  describe ".to_proto" do
    it "get base64 string with call" do
      transaction = Nebulas::Transaction.new(
        chain_id: 1001, 
        from: account, 
        to: 'n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC', 
        value: 10000,
        nonce: 100001010,
        payload_type: 'call',
        payload: Nebulas::Tx::DeployPayload.new('func', 'i=1'),
        gas_price: 1000,
        gas_limit: 1100)
      tx = Nebulas::Transaction.from_proto(Base64.decode64(transaction.to_proto_str))
      expect(tx.gas_price).to eq(1000)
      expect(tx.gas_limit).to eq(1100)
      expect(tx.nonce).to eq(100001010)
      expect(tx.gas_limit).to eq(1100)
      expect(tx.to).to eq('n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC')
      expect(tx.chain_id).to eq(1001)
      expect(tx.payload_type).to eq('call')
    end

    it "get base64 string with binary" do
      transaction = Nebulas::Transaction.new(
        chain_id: 1001, 
        from: account, 
        to: 'n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC', 
        value: 10000,
        nonce: 100001010,
        payload_type: 'binary',
        payload: Nebulas::Tx::BinaryPayload.new('u29329kjhskdadk'),
        gas_price: 1000,
        gas_limit: 1100)
      tx = Nebulas::Transaction.from_proto(Base64.decode64(transaction.to_proto_str))
      expect(tx.gas_price).to eq(1000)
      expect(tx.gas_limit).to eq(1100)
      expect(tx.nonce).to eq(100001010)
      expect(tx.gas_limit).to eq(1100)
      expect(tx.to).to eq('n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC')
      expect(tx.chain_id).to eq(1001)
      expect(tx.payload_type).to eq('binary')
    end

    it "get base64 string with deploy" do
      tx = Nebulas::Transaction.from_proto(Base64.decode64(transaction.to_proto_str))
      expect(tx.gas_price).to eq(1000)
      expect(tx.gas_limit).to eq(1100)
      expect(tx.nonce).to eq(100001010)
      expect(tx.gas_limit).to eq(1100)
      expect(tx.to).to eq('n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC')
      expect(tx.chain_id).to eq(1001)
      expect(tx.payload_type).to eq('deploy')
    end
  end

  describe ".from_proto" do
    it "instance transaction with call func" do
      encoded_text = "CiDDzOJz/HxzIBRTgDl20/p6t3ZRw0+xoewkwJh3Q2fuuhIaGVcH+WT/SVMkY18ix7SG4F1+Z8evXJoA35caGhlXJ3pmMH7bRAY5DQRcK3GRIGkPZHKdhlzhIhAAAAAAAAAAAAAAAOjUpRAAKOkHMKz/7NkFOigKBGNhbGwSIHsiRnVuY3Rpb24iOiJzYXZlIiwiQXJncyI6IlswXSJ9QGVKEAAAAAAAAAAAAAAAAAAPQkBSEAAAAAAAAAAAAAAAAAAehIBYAWJBc+KJyXmqLBnsj+S7LEY2rDkP8SISKMzk6zBmEm8lCj5Yn3sXJw8iSFsMrvyjQRwgYjhhFSeWt3HzpWcZt8m8JwE="
      tx = Nebulas::Transaction.from_proto(Base64.decode64(encoded_text))
      expect(tx.to_proto_str).to eq(encoded_text)
      expect(tx.payload_type).to eq('call')
    end

    it "instance transaction with deploy func" do
      encoded_text = "CiDbLm9JU5gl6q7BzFidoyK+tEdwo2gb4hOZobGec6Yi1BIaGVcH+WT/SVMkY18ix7SG4F1+Z8evXJoA35caGhlXJ3pmMH7bRAY5DQRcK3GRIGkPZHKdhlzhIhAAAAAAAAAAAAAAAOjUpRAAKOkHMIGB7dkFOi4KBmRlcGxveRIkeyJTb3VyY2VUeXBlIjoianMiLCJTb3VyY2UiOiJpID0gMiJ9QGVKEAAAAAAAAAAAAAAAAAAPQkBSEAAAAAAAAAAAAAAAAAAehIBYAWJBiVhcm3sNoNbpMCbcslR2boLvLlHrb7gQORf9xUsuzilOtakzq2eDUxTO+edoV254vLgnmqthcAzQ9qybgNjznAA="
      tx = Nebulas::Transaction.from_proto(Base64.decode64(encoded_text))
      expect(tx.to_proto_str).to eq(encoded_text)
      expect(tx.payload_type).to eq('deploy')
    end

     it "instance transaction with binary func" do
      encoded_text = "CiAZPe6EVnqgjHHeL2HLTqVPt/5yCXTOx101xMqV+pXXrhIaGVcH+WT/SVMkY18ix7SG4F1+Z8evXJoA35caGhlXJ3pmMH7bRAY5DQRcK3GRIGkPZHKdhlzhIhAAAAAAAAAAAAAAAOjUpRAAKOkHMPSU7dkFOggKBmJpbmFyeUBlShAAAAAAAAAAAAAAAAAAD0JAUhAAAAAAAAAAAAAAAAAAHoSAWAFiQQ9fr0HLweR56A16uFWN+OG37LsYcZ9Lmoyk8d423PCBIu4cP865h/UP+DRatxsnYxNYB2Bt7WtmJxSwhOFYPy4A"
      tx = Nebulas::Transaction.from_proto(Base64.decode64(encoded_text))
      expect(tx.to_proto_str).to eq(encoded_text)
      expect(tx.payload_type).to eq('binary')
    end
  end
end




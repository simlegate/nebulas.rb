require 'base64'
RSpec.describe Nebulas::Account do
  let(:private_key){
    "3d55e39c7267b64cedce79519ff790c13e7d24f5ad17308a48a76cc9d5cf18de"
  }
  let(:address) {
    "n1FJ17N3PxrCJkQ5Yj5pPktfde9QxZD9NkM"
  }
  let(:account) {
    account = Nebulas::Account.new(private_key)
  }
  describe "#initialize" do
    it "generate random account" do
      account = Nebulas::Account.new
      expect(account.private_key).to be_instance_of(OpenSSL::BN)
      expect(account.public_key).to be_instance_of(OpenSSL::PKey::EC::Point)
      expect(account.address).to be_instance_of(Nebulas::Address)
    end

    it "specify private_key" do
      expect(account.private_key).to be_instance_of(OpenSSL::BN)
      expect(account.public_key).to be_instance_of(OpenSSL::PKey::EC::Point)
      expect(account.address).to be_instance_of(Nebulas::Address)
      expect(account.private_key_str).to eq(private_key)
    end
  end

  describe "#addr_str" do
    it "get human-readable address" do
      expect(account.addr_str).to eq(address)
    end
  end

  it "#sign" do
    expect(hex_str?(account.sign("password"))).to be true
  end

  describe "#verify" do
    it "return true when sign is correct" do
      sign = "3046022100936bbdf53d7815778a0959facbc610b7abea7e688cab857fe67c96292089d85f0221009e8e458434d91638c6448d6d0af58644385fc079409d0a9eb4405c6bf302fd41"
      expect(account.verify("password", sign)).to be true
    end

    it "return true when sign is wrong" do
      expect(account.verify("password", "3046022100936bbdf53d78")).to be false
    end
  end

  it "#private_key_str" do
    expect(hex_str?(account.private_key_str)).to be true
  end

  it "#pubilc_key_str" do
    expect(hex_str?(account.pubilc_key_str)).to be true
  end

  describe ".from_keystore" do
    it "get account instance" do
      restored_account = Nebulas::Account.from_keystore(account.keystore("123456"), "123456")
      expect(restored_account.addr_str).to eq(account.addr_str)
      expect(restored_account.private_key_str).to eq(account.private_key_str)
      expect(restored_account.pubilc_key_str).to eq(account.pubilc_key_str)
    end
  end
end

RSpec.describe Nebulas::Address do
  describe "#valid?" do
    it "validate a right address" do
      expect(Nebulas::Address.valid?('n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC')).to be true
    end

    it "validate a wrong address without starting of _n_" do
      expect(Nebulas::Address.valid?('N1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC')).to be false
    end

    it "validate a wrong address whose length does not equals 35" do
      expect(Nebulas::Address.valid?('n11TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC')).to be false
    end

    it "validate a wrong address whose format is wrong" do
      expect(Nebulas::Address.valid?('n1111111111111111111111111111111111')).to be false
    end
  end
end

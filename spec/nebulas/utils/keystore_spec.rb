RSpec.describe Nebulas::Utils::Keystore do
	let(:private_key) {
		"F7CFAE03A4E3CB285550F3251798F0DAF57AACCDBAF1FF0EFFF91A900E296269"
	}

	let(:password) { "123456" }

	describe "generate" do
		let(:keystore){
			Nebulas::Utils::Keystore.generate(private_key, password)
		}
		it "get hash" do
			expect(keystore).to be_an_instance_of(Hash)
		end

		it "has 32-hex iv" do
			iv = keystore[:crypto][:cipherparams][:iv]
			expect(hex_str?(iv)).to be true
			expect(iv.bytesize).to eq(32)
		end

		it "has hex ciphertext" do
			ciphertext = keystore[:crypto][:ciphertext]
			expect(hex_str?(ciphertext)).to be true
		end


		it "has hex ciphertext whose length is 64" do
			ciphertext = keystore[:crypto][:ciphertext]
			expect(ciphertext.bytesize).to eq(64)
		end

		it "has 64-hex salt" do
			salt = keystore[:crypto][:kdfparams][:salt]
			expect(hex_str?(salt)).to be true
			expect(salt.bytesize).to eq(64)
		end

		it "has correct mac" do
			mac = keystore[:crypto][:mac]
			kdfparams = keystore[:crypto][:kdfparams]
			UTILS = Nebulas::Utils
			dk = UTILS::Crypto.scrypt password, { salt: UTILS::BinUtil.from_hex(kdfparams[:salt]), 
						                                N: kdfparams[:n], 
						                                r: kdfparams[:r], 
						                                p: kdfparams[:p], 
						                                length: kdfparams[:dklen]}
	    encrypted_mac = UTILS::Crypto.digest_with_sha3(dk[16...32] + UTILS::BinUtil.from_hex(keystore[:crypto][:ciphertext]))
	    expect(UTILS::BinUtil.to_hex(encrypted_mac)).to eq(mac)
		end

		it "has address" do
			expect(keystore[:address].start_with?('n')).to be true
		end
	end

	describe "restore" do
		let(:keystore){
			JSON.parse(file_fixture("keystore.json").read)
		}

		it "receive error when password is wrong" do
			expect { Nebulas::Utils::Keystore.restore(keystore, '12345678') }.to raise_error(RuntimeError, "Invalid Password")
		end

		it "get Account instance" do
			expect(Nebulas::Utils::Keystore.restore(keystore, '123456789')).to be_an_instance_of(Nebulas::Account)
		end

		it "built-in keystore" do
			keystore = JSON.parse(file_fixture("built-in_keystore.json").read)
			acccount = Nebulas::Utils::Keystore.restore(keystore, '123456')
			expect(acccount).to be_an_instance_of(Nebulas::Account)
			expect(keystore["address"]).to eq(acccount.addr_str)
		end
	end
end

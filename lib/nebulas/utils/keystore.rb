require 'securerandom'

module Nebulas
  module Utils
    module Keystore
      def self.generate private_key, password
        salt = SecureRandom.random_bytes(32)
        dk = Utils::Crypto.scrypt(password, salt: salt, 
                                           N: self.kdfparams[:n], 
                                           r: self.kdfparams[:r], 
                                           p: self.kdfparams[:p], 
                                           length: self.kdfparams[:dklen])
        encrypted = Utils::Crypto.encrypt_with_AES128(Utils::BinUtil.from_hex(private_key), dk[0...16])
        mac = Utils::Crypto.digest_with_sha3(dk[16...32] + encrypted[:ciphertext])
        account = Account.new(private_key)
        {
          crypto: {
            cipher: "aes-128-ctr",
            cipherparams: {
              iv: encrypted[:hexiv]
            },
            ciphertext: encrypted[:hexciphertext],
            kdf: 'scrypt',
            kdfparams: self.kdfparams.merge(salt: Utils::BinUtil.to_hex(salt)),
            mac: Utils::BinUtil.to_hex(mac),
            machash: 'sha3256'
          },
          id: SecureRandom.uuid,
          version: 3,
          address: account.addr_str,
        }
      end

      def self.restore keystore, password
        keystore = HashUtil.symbolize_keys(keystore)
        cryptoparams = keystore[:crypto]
        kdfparams = cryptoparams[:kdfparams]
        cipherparams = cryptoparams[:cipherparams]
        cipher_bin = BinUtil.from_hex(cryptoparams[:ciphertext])
        dk = Utils::Crypto.scrypt password, salt: Utils::BinUtil.from_hex(kdfparams[:salt]), 
                                            N: kdfparams[:n], 
                                            r: kdfparams[:r], 
                                            p: kdfparams[:p], 
                                            length: kdfparams[:dklen]
        mac = Utils::Crypto.digest_with_sha3(dk[16...32] + cipher_bin)
        raise "Invalid Password" if BinUtil.to_hex(mac) != cryptoparams[:mac]
        private_key = Utils::Crypto.decrypt_with_AES128(cipher_bin, dk[0...16], BinUtil.from_hex(cipherparams[:iv]))
        Account.new(Utils::BinUtil.to_hex(private_key))
      end

      def self.kdfparams
        {
          n: 4096,
          r: 8,
          p: 1,
          dklen: 32
        }
      end
    end
  end
end
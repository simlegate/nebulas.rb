require 'digest'
require 'sha3'

module Nebulas
	module Utils
		module Crypto

      def self.ec_from_private private_key
        group = OpenSSL::PKey::EC::Group.new('secp256k1')
        private_key_bn = OpenSSL::BN.new(private_key, 16)
        ec = OpenSSL::PKey::EC.new('secp256k1')
        public_key = group.generator.mul(private_key_bn)
        ec.public_key = public_key
        ec.private_key = private_key_bn
        ec
      end

      def self.random_ec
        ec = OpenSSL::PKey::EC.new('secp256k1')
        ec.generate_key
        ec
      end

      def self.create_private_key
        ec = self.random_ec
        ec.generate_key
        ec.to_pem
      end

      def self.private_to_public private_key
        ec = self.ec_from_private(private_key)
        ec.public_key
      end

      def self.digest_with_sha3 content
        SHA3::Digest::SHA256.digest(content)
      end

      def self.digest_with_rmd160 content
        Digest::RMD160.digest content 
      end

      def self.base58encode content
        Base58.binary_to_base58(content, :bitcoin)
      end

      def self.base58decode content
        Base58.base58_to_binary(content, :bitcoin)
      end

      def self.encrypt_with_AES128 content, key
        cipher = OpenSSL::Cipher::AES.new(128, :CTR)
        cipher.encrypt
        cipher.key = key
        iv = cipher.random_iv
        ciphertext = cipher.update(content) + cipher.final
        {
          ciphertext: ciphertext,
          hexciphertext: Utils::BinUtil.to_hex(ciphertext),
          iv: iv,
          hexiv: Utils::BinUtil.to_hex(iv)
        }
      end

      def self.decrypt_with_AES128 content, key, iv
        cipher = OpenSSL::Cipher::AES.new(128, :CTR)
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv
        cipher.update(content) + cipher.final
      end

      def self.scrypt password, kdfparams
        OpenSSL::KDF.scrypt(password, kdfparams)
      end
		end
	end
end

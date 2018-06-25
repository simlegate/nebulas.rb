require "bundler/setup"
require "nebulas"

def print_account_info account
  p "the private key of this account: #{account.private_key_str}"

  p "the public key of this account: #{account.pubilc_key_str}"

  p "the address of this account: #{account.addr_str}"

  content = "hello world"

  p "signing the data[#{content}]"

  sign = account.sign(content)

  p "signature is #{sign}"

  p "verify the signature"

  result = account.verify(content, sign)

  p "signature is correct"

  p "the keystore of this account:"

  password = "123456789"
  keystore = account.keystore(password)

  print keystore.to_json

  p "restore account from keystore"

  restored_account = Nebulas::Account.from_keystore(keystore, password)
  p "whether private key is right ? #{restored_account.private_key_str == account.private_key_str}"
  p "whether public key is right ? #{restored_account.pubilc_key_str == account.pubilc_key_str}"
  p "whether address is right ? #{restored_account.addr_str == account.addr_str}"
end

p "="*80
p 'create account with random key-pairs'
account = Nebulas::Account.new
print_account_info account
p "="*80
p 'create account with private key'
account = Nebulas::Account.new("F7CFAE03A4E3CB285550F3251798F0DAF57AACCDBAF1FF0EFFF91A900E296269")
print_account_info account
p "="*80

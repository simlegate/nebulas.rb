require "bundler/setup"
require "nebulas"

p "*"*100
p "connecting to test network of nebulas..........."
p "*"*100

chain = Nebulas::Blockchain.new(Nebulas::HttpClient.new('test'))

p "Return the state of the neb"
p chain.neb_state

p "Return the state of the account"
p chain.account_state("n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC")

p "Return the latest irreversible block"
p chain.latest_irreversible_block
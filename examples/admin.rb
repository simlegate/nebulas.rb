require "bundler/setup"
require "nebulas"

def print_output title
  p '='*100
  p title
  p '-'*100
  p yield
end


p '*'*100
p '!!!!!!!!!!!!!!!NOTICE!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
p 'Only Connect to LOCAL NETWORK'
p "connecting to local network of nebulas..........."
p "*"*100

chain = Nebulas::Blockchain.new()
admin = Nebulas::Admin.new

print_output 'Return the p2p node info.' do
  admin.node_info
end

print_output 'Return account list.' do
  admin.accounts
end

print_output "create a new account with passphrase." do
  admin.create_account('123456789')
end

print_output "unlock account with passphrase." do
  admin.unlock_account('n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3', "123456789", 1000000)
end

print_output "lock account." do
  admin.lock_account('n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3')
end

print_output "sign transaction. " do
  admin.sign_tx_with_pwd({from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", 
                          to: "n1mL2WCZyRi1oELEugfCZoNAW3dt8QpHtJw",
                          value: "0", 
                          nonce: "3", 
                          gasPrice: "1000000", 
                          gasLimit: "2000000",
                          contract: {function: "transferValue", args: "[500]"}}, "123456789")
end

print_output "send transaction with passphrase." do
  admin.send_tx_with_pwd({from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", 
                          to: "n1mL2WCZyRi1oELEugfCZoNAW3dt8QpHtJw",
                          value: "0", 
                          nonce: "3", 
                          gasPrice: "1000000", 
                          gasLimit: "2000000",
                          contract: {function: "transferValue", args: "[500]"}}, "123456789")
end

print_output "Send the transaction. " do
  admin.send_transaction({from: "n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", 
                          to: "n1mL2WCZyRi1oELEugfCZoNAW3dt8QpHtJw",
                          value: "0", 
                          nonce: "3", 
                          gasPrice: "1000000", 
                          gasLimit: "2000000",
                          contract: {function: "transferValue", args: "[500]"}})
end

print_output "sign the hash of a message." do
  admin.sign_hash("n1Z6SbjLuAEXfhX1UJvXT6BB5osWYxVg3F3", "W+rOKNqs/tlvz02ez77yIYMCOr2EubpuNh5LvmwceI0=")
end

print_output "starts pprof" do
  admin.start_pprof("0.0.0.0:1234")
end

print_output "return the config current neb is using" do
  admin.config
end
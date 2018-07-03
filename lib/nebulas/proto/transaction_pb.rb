# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: transaction.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "corepb.Data" do
    optional :payload_type, :string, 1
    optional :payload, :bytes, 2
  end
  add_message "corepb.Transaction" do
    optional :hash, :bytes, 1
    optional :from, :bytes, 2
    optional :to, :bytes, 3
    optional :value, :bytes, 4
    optional :nonce, :uint64, 5
    optional :timestamp, :int64, 6
    optional :data, :message, 7, "corepb.Data"
    optional :chain_id, :uint32, 8
    optional :gas_price, :bytes, 9
    optional :gas_limit, :bytes, 10
    optional :alg, :uint32, 11
    optional :sign, :bytes, 12
  end
end

module Corepb
  Data = Google::Protobuf::DescriptorPool.generated_pool.lookup("corepb.Data").msgclass
  Transaction = Google::Protobuf::DescriptorPool.generated_pool.lookup("corepb.Transaction").msgclass
end

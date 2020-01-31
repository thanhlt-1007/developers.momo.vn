require "openssl"
require "base64"
require "json"

raw_data = {
  partnerCode: "MOMO5G4K20180302",
  requestId: "410458",
  amount: 110000,
  signature: "410458"
}

puts "--------------------KEY----------------"
key = OpenSSL::PKey::RSA.new File.read "key.pem"
puts "key: #{key}"

puts "--------------------ENCRYPTED STRING----------------"
encrypted_string = key.public_encrypt(JSON.pretty_generate(raw_data))
puts "encrypted_string: #{encrypted_string}"

puts "--------------------ECODED STRING----------------"
encoded_str = Base64.encode64(encrypted_string)
puts "encoded_str: #{encoded_str}"

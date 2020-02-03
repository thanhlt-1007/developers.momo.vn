require "openssl"
require "securerandom"
require "json"
require "uri"
require "net/https"

serect_key = "K951B6PE1waDMi640xX08PD3vg6EkVlz"

partner_code = "MOMO"
access_key = "F8BBA842ECF85"
request_id = SecureRandom.uuid
amount = "50000"
order_id = SecureRandom.uuid
order_info = "pay with MoMo"
return_url = "https://momo.vn/return"
notify_url = "https://dummy-url.vn/notify"
extra_data = "merchantName=;merchantId="

puts "--------------------RAW SIGNATURE----------------"
raw_signature = "partnerCode=" + partner_code +
  "&accessKey=" + access_key +
  "&requestId=" + request_id +
  "&amount=" + amount +
  "&orderId=" + order_id +
  "&orderInfo=" + order_info +
  "&returnUrl=" + return_url +
  "&notifyUrl=" + notify_url +
  "&extraData=" + extra_data
puts raw_signature

puts "--------------------SIGNATURE----------------"
signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), serect_key, raw_signature)
puts signature

puts "--------------------JSON REQUEST----------------"
request_type = "captureMoMoWallet"
end_point = "https://test-payment.momo.vn/gw_payment/transactionProcessor"

json_request = {
  partnerCode: partner_code,
  accessKey: access_key,
  requestId: request_id,
  amount: amount,
  orderId: order_id,
  orderInfo: order_info,
  returnUrl: return_url,
  notifyUrl: notify_url,
  extraData: extra_data,
  requestType: request_type,
  signature: signature
}
puts JSON.pretty_generate(json_request)

puts "--------------------SEND REQUEST----------------"
uri = URI.parse(end_point)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(uri.path)
request.add_field('Content-Type', 'application/json')
request.body = json_request.to_json

puts "SENDING...."
# response = http.request(request)
# result = JSON.parse(response.body)

# puts "--------------------RESPONSE----------------"
# puts JSON.pretty_generate(result)
# if result["errorCode"] == 0
#   puts "Success"
#   puts "pay URL is: " + result["payUrl"]
# else
#   puts "Fail"
#   puts "Error is: " + result["localMessage"]
# end

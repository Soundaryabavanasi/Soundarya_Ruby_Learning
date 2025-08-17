require 'net/http'
require 'uri'
require 'json'

# Step 1: Define the API endpoint
url = URI.parse("https://jsonplaceholder.typicode.com/posts/1")

# Step 2: Create HTTP request
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true  # HTTPS

request = Net::HTTP::Get.new(url)

# Step 3: Send request and get response
response = http.request(request)

# Step 4: Log status code
puts "Status Code: #{response.code}"

# Step 5: Log headers
puts "Headers:"
response.each_header do |key, value|
  puts "  #{key}: #{value}"
end

# Step 6: Parse JSON payload
payload = JSON.parse(response.body)
puts "\nPayload:"
puts JSON.pretty_generate(payload)

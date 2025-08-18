require 'rest-client'
require 'json'

BASE_URL = "https://jsonplaceholder.typicode.com/posts"

begin
  # Step 1: Create a post
  puts "\n=== POST /posts (create) ==="
  create_payload = { title: "My first post", body: "Hello world!", userId: 42 }
  create_response = RestClient.post(BASE_URL, create_payload.to_json, { content_type: :json, accept: :json })
  puts "Status: #{create_response.code}"
  created_post = JSON.parse(create_response.body)
  puts "Created ID: #{created_post['id']}" # always 101 on jsonplaceholder

  # ⚡ Workaround: Use an existing ID (say 1) for update instead of 101
  update_id = 1  

  # Step 2: Update the post
  puts "\n=== PUT /posts/#{update_id} (update) ==="
  update_payload = { title: "Updated Title", body: "Updated content!", userId: 42 }
  update_response = RestClient.put("#{BASE_URL}/#{update_id}", update_payload.to_json, { content_type: :json, accept: :json })
  puts "Status: #{update_response.code}"
  puts "Updated Payload: #{update_response.body}"

rescue RestClient::ExceptionWithResponse => e
  puts "\n❌ HTTP error: #{e.response.code}"
  puts e.response.body
end

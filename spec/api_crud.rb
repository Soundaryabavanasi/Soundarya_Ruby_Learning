require 'rest-client'.   # loads the RestClient gem. This library makes it easy to send HTTP requests (GET, POST, PUT, DELETE).
require 'json'
require 'rspec'

RSpec.describe 'JSONPlaceholder API CRUD operations' do
  base_url = "https://jsonplaceholder.typicode.com/posts"

  it 'creates a new post (POST)' do
    payload = {
      title: 'foo',
      body: 'bar',
      userId: 1
    }

    response = RestClient.post(base_url, payload.to_json, {content_type: :json, accept: :json})

    puts "POST Status: #{response.code}"
    parsed = JSON.parse(response.body)
    puts "POST Response: #{parsed}"

    expect(response.code).to eq(201) # Created
    expect(parsed['title']).to eq('foo')
    expect(parsed['body']).to eq('bar')
  end

  it 'updates an existing post (PUT)' do
    payload = {
      id: 1,
      title: 'updated title',
      body: 'updated body',
      userId: 1
    }

    response = RestClient.put("#{base_url}/1", payload.to_json, {content_type: :json, accept: :json})

    puts "PUT Status: #{response.code}"
    parsed = JSON.parse(response.body)
    puts "PUT Response: #{parsed}"

    expect(response.code).to eq(200)
    expect(parsed['title']).to eq('updated title')
    expect(parsed['body']).to eq('updated body')
  end

  it 'deletes a post (DELETE)' do
    response = RestClient.delete("#{base_url}/1")

    puts "DELETE Status: #{response.code}"
    puts "DELETE Response: #{response.body.inspect}" # Should be empty

    expect(response.code).to eq(200) # JSONPlaceholder returns 200 even though no real deletion happens
  end
end

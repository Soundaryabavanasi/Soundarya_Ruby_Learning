require 'rest-client'
require 'json'
require 'rspec'

RSpec.describe 'JSONPlaceholder API CRUD operations' do
  base_url = "https://jsonplaceholder.typicode.com/posts"

  # POST request validation
  it 'creates a new post (POST)' do
    payload = { title: 'foo', body: 'bar', userId: 1 }

    response = RestClient.post(base_url, payload.to_json, { content_type: :json, accept: :json })

    parsed = JSON.parse(response.body)

    # Status code validation
    expect(response.code).to eq(201) # Created

    # Payload validation
    expect(parsed['title']).to eq('foo')
    expect(parsed['body']).to eq('bar')
    expect(parsed['userId']).to eq(1)
  end

  # PUT request validation
  it 'updates an existing post (PUT)' do
    payload = { id: 1, title: 'updated title', body: 'updated body', userId: 1 }

    response = RestClient.put("#{base_url}/1", payload.to_json, { content_type: :json, accept: :json })

    parsed = JSON.parse(response.body)

    # Status code validation
    expect(response.code).to eq(200) # OK

    # Payload validation
    expect(parsed['title']).to eq('updated title')
    expect(parsed['body']).to eq('updated body')
    expect(parsed['id']).to eq(1)
  end

  # ✅ DELETE request validation
  it 'deletes a post (DELETE)' do
    response = RestClient.delete("#{base_url}/1")

    # Status code validation
    expect(response.code).to eq(200) # JSONPlaceholder always returns 200

    # Body validation
    expect(response.body).to eq("{}").or eq("") # usually empty after delete
  end
end

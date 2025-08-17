require 'rest-client'
require 'json'
require 'rspec'

RSpec.describe 'JSONPlaceholder API' do
  it 'fetches a post and validates the response' do
    url = "https://jsonplaceholder.typicode.com/posts/1"
    response = RestClient.get(url)

    # Log response info
    puts "Status code: #{response.code}"
    puts "Headers: #{response.headers}"
    payload = JSON.parse(response.body)
    puts "Payload: #{payload}"

    # Status code validation
    expect(response.code).to eq(200)

    # Validate keys and values
    expect(payload).to have_key('id')
    expect(payload['id']).to eq(1)
    expect(payload['title']).not_to be_empty
    expect(payload['body']).not_to be_empty
  end
end

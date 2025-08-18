require 'rest-client'
require 'json'
require 'rspec'
require 'yaml'

RSpec.describe 'JSONPlaceholder API with parameterized inputs' do
  base_url = "https://jsonplaceholder.typicode.com/posts"
  test_data = YAML.load_file(File.join(__dir__, 'test_data', 'test_data.yml'))

  # Loop through each entry in YAML
  test_data['posts'].each do |data|
    it "creates a post with title: '#{data['title']}' and userId: #{data['userId']}" do
      response = RestClient.post(base_url, data.to_json, { content_type: :json, accept: :json })
      parsed = JSON.parse(response.body)

      # Status code validation
      expect(response.code).to eq(201)

      # Payload validation
      expect(parsed['title']).to eq(data['title'])
      expect(parsed['body']).to eq(data['body'])
      expect(parsed['userId']).to eq(data['userId'])
    end
  end
end

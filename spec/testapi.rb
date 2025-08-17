require_relative '../pages/api_helper'
require 'rspec'
require 'rest-client'
require 'json'

RSpec.describe 'API Tests with Helper' do
  before(:all) do
    @api = ApiHelper.new("https://jsonplaceholder.typicode.com")
  end

  it 'validates GET /posts/1' do
    response = @api.get("/posts/1")
    expect(response[:status]).to eq(200)
    expect(response[:body]['id']).to eq(1)
  end
end

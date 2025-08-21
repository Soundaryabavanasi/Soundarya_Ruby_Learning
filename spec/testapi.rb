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


## /posts is a resource endpoint that represents a collection of “blog posts.”

## Each post has fields like:

## {
 ## "userId": 1,
 ## "id": 1,
 ## "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 ## "body": "quia et suscipit..."
## }

## JSONPlaceholder is a fake API for testing. They made “posts” as example data (like blog posts/articles).
## It could have been “tickets,” “products,” or “users.”
##cIn your case, you’re testing against this dummy dataset.




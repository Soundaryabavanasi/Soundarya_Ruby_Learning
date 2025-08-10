# spec/matchers_demo_spec.rb

require 'rspec'

# Dummy class to demonstrate matchers
class Demo
  attr_reader :content

  def initialize(content = "")
    @content = content
  end

  def status_active?
    true
  end

  def risky_method
    raise ArgumentError, "Something went wrong!"
  end
end

RSpec.describe Demo do
  before(:each) do
    @demo = Demo.new("Hello World")
  end

  # 1. `be` matcher: used for predicate methods or truthy/falsy checks
  it 'checks if status is active using `be` matcher' do
    expect(@demo.status_active?).to be true   # checks if status_active? returns true
    expect(@demo.status_active?).to be_truthy # alternative: checks truthiness
  end

  # 2. `have_content` matcher: usually from Capybara, here we mimic it with string include
  # Since `have_content` is a Capybara matcher, in pure RSpec you use `include` or `match`.
  it 'checks if content includes expected text using `have_content` style' do
    expect(@demo.content).to include("Hello") # similar to have_content in Capybara
  end

  # 3. `raise_error` matcher: checks if a block raises an error
  it 'raises an ArgumentError with specific message' do
    expect { @demo.risky_method }.to raise_error(ArgumentError, "Something went wrong!")
  end
end

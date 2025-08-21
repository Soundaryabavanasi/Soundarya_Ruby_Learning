require 'spec_helper'

RSpec.describe 'Sample Test' do
  it 'checks addition' do
    result = 1 + 1
    puts "Calculated value: #{result}, Expected value: 2"

    expect(result).to eq(2)
  end
end

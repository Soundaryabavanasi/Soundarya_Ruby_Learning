# form_submission_spec.rb
require 'spec_helper'
require 'selenium-webdriver'
require 'rspec'

RSpec.describe 'Demo Form Submission' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @driver.navigate.to 'https://demoqa.com/text-box'
  end

  after(:all) do
    sleep 5 # so you can see the last state before browser closes
    @driver.quit
  end

  def fill_form(name:, email:, current_address:, permanent_address:)
    @driver.find_element(:id, 'userName').clear
    @driver.find_element(:id, 'userName').send_keys(name)

    @driver.find_element(:id, 'userEmail').clear
    @driver.find_element(:id, 'userEmail').send_keys(email)

    @driver.find_element(:id, 'currentAddress').clear
    @driver.find_element(:id, 'currentAddress').send_keys(current_address)

    @driver.find_element(:id, 'permanentAddress').clear
    @driver.find_element(:id, 'permanentAddress').send_keys(permanent_address)
  end

  def submit_form
    @driver.find_element(:id, 'submit').click
  end

  def get_output_value(id)
    @driver.find_element(:id, id).text
  end

  it 'submits form successfully and validates output' do
    fill_form(
      name: 'Soundarya',
      email: 'soundarya@example.com',
      current_address: 'Kadapa',
      permanent_address: 'Hyderabad'
    )

    submit_form

    expect(get_output_value('name')).to include('Soundarya')
    expect(get_output_value('email')).to include('soundarya@example.com')

    output = @driver.find_element(:id, 'output').text
    expect(output).to include('Kadapa')
    expect(output).to include('Hyderabad')
  end

  it 'does not show output for invalid email' do
    @driver.navigate.refresh

    fill_form(
      name: 'Soundarya',
      email: 'invalid-email',
      current_address: 'Kadapa',
      permanent_address: 'Hyderabad'
    )

    submit_form

    output = @driver.find_element(:id, 'output').text
    expect(output).not_to include('invalid-email')
  end
end

require 'selenium-webdriver'
require 'rspec'

describe 'DemoQA Text Box Form' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome.      ## Opening the browser in the window and making sure the browser is ready before the test cases run
    @driver.manage.window.maximize
    @driver.navigate.to 'https://demoqa.com/text-box'
  end

  after(:all) do
    @driver.quit
  end

  it 'fills and submits the form, then validates output' do
    fill_text_fields
    click_submit_button
    validate_output
  end

  def fill_text_fields
    @driver.find_element(:id, 'userName').send_keys('Soundarya')
    @driver.find_element(:id, 'userEmail').send_keys('soundarya@example.com')
    @driver.find_element(:id, 'currentAddress').send_keys('Kadapa, Andhra Pradesh')
    @driver.find_element(:id, 'permanentAddress').send_keys('Hyderabad')
  end

  def click_submit_button
    @driver.find_element(:id, 'submit').click
  end

  def validate_output
    name = @driver.find_element(:id, 'name').text
    email = @driver.find_element(:id, 'email').text
    address = @driver.find_element(:xpath, "//p[@id='currentAddress']").text

    expect(name).to include('Soundarya')
    expect(email).to include('soundarya@example.com')
    expect(address).to include('Kadapa')
  end
end

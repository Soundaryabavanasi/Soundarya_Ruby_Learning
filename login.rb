require 'selenium-webdriver'
require 'rspec'

describe 'Login and Logout Flow' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
  end

  it 'logs into the website and logs out' do
    @driver.navigate.to 'https://the-internet.herokuapp.com/login'

    # Fill in username and password
    @driver.find_element(:id, 'username').send_keys('tomsmith')
    @driver.find_element(:id, 'password').send_keys('SuperSecretPassword!')

    # Click the login button
    @driver.find_element(:css, 'button[type="submit"]').click

    # Wait and check if login was successful
    success_message = @driver.find_element(:css, '.flash.success').text
    expect(success_message).to include('You logged into a secure area!')

    # Click logout button
    @driver.find_element(:css, 'a.button.secondary.radius').click

    # Confirm logout success
    logout_message = @driver.find_element(:css, '.flash.success').text
    expect(logout_message).to include('You logged out of the secure area!')
  end

  after(:all) do
    @driver.quit
  end
end

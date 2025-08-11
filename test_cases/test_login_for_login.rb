require 'selenium-webdriver'
require 'rspec'
require 'dotenv/load'  # This loads ENV variables from .env
require_relative '../pages/login'

RSpec.describe 'Freshservice Login' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @login_page = LoginPage.new(@driver)
  end

  it 'logs in successfully using environment variables' do
    email = ENV['FRESHSERVICE_EMAIL']
    password = ENV['FRESHSERVICE_PASSWORD']

    @login_page.open
    @login_page.login(email, password)

    sleep 5  # Just for demo, replace with proper wait condition
    expect(@driver.current_url).to include('dashboard') # Update based on actual URL after login
  end

  after(:all) do
    @driver.quit
  end
end

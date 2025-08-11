require 'selenium-webdriver'
require 'rspec'
require_relative '../pages/login_page'

RSpec.describe 'Login Test' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @driver.navigate.to 'freshworkshelpdesk527-695210703739135957.myfreshworks.com/login/normal'
    @login_page = LoginPage.new(@driver)
  end

  it 'logs in successfully' do
    @login_page.enter_email('bhavanasi.ramalinga1@freshworks.com')
    @login_page.enter_password('Sound@123')
    @login_page.click_login
    expect(@driver.current_url).to include('/dashboard')
  end

  after(:all) do
    @driver.quit
  end
end

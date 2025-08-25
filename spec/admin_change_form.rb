require 'selenium-webdriver'
require 'rspec'
require_relative '../pages/login'
require_relative '../pages/change_form'
require_relative '../pages/change_business_rules'
require 'dotenv/load'


RSpec.describe 'Admin Workspace & Field Manager Flow' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)

    @login_page = LoginPage.new(@driver)
    @admin_page = AdminPage.new(@driver)
    @business_rules = Changebusinessrules.new(@driver)
    # Open login page and login
    @login_page.open(ENV['FRESHSERVICE_URL'])
    @login_page.login(ENV['FRESHSERVICE_EMAIL'], ENV['FRESHSERVICE_PASSWORD'])
    sleep 3 # TODO: Replace with explicit wait for login success
  end

  it 'navigates to IT workspace and opens Field Manager' do
    @admin_page.open_admin
    @admin_page.switch_from_global_to_first_workspace
    @admin_page.open_field_manager
    @admin_page.click_change_fields
    @admin_page.click_text_field
    @admin_page.click_done_button
    @admin_page.save_form
  end

  it "creates a Change Business Rule" do
    @business_rules.create_change_business_rule("Auto Change Rule", "IT Support")
  end


  after(:all) do
    @driver.quit
  end
end

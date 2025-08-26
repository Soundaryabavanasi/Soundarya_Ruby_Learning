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
    @business_rules = ChangeBusinessRules.new(@driver)
    # Open login page and login
    @login_page.open(ENV['FRESHSERVICE_URL'])
    @login_page.login(ENV['FRESHSERVICE_EMAIL'], ENV['FRESHSERVICE_PASSWORD'])
    sleep 3 # TODO: Replace with explicit wait for login success
  end

  fit 'navigates to IT workspace and opens Field Manager' do
    @admin_page.open_admin
    @admin_page.switch_from_global_to_first_workspace
    @admin_page.open_field_manager
    @admin_page.click_change_fields
    @admin_page.add_two_custom_fields_and_done
    @admin_page.click_input_save_button
    @admin_page.go_back_workspace
  end


  it 'creates a new Change Business Rule and assigns to a group' do
    
    # Call the page object method


   rule_name   = "Automation_Rule_#{Time.now.to_i}"
    description = "Auto-created rule via Selenium"

    # Step 1: Navigate to Admin > Business Rules > Change
    @business_rules.create_change_business_rule

    # Step 2: Fill in the form with values
    @business_rules.fill_change_business_rule_form(
      rule_name:   rule_name,
      description: description
    )

    # Step 3: Verify the rule got created
    rule_locator = "//td[contains(text(),'#{rule_name}')]"
    created_rule = Selenium::WebDriver::Wait.new(timeout: 10)
      .until { @driver.find_element(:xpath, rule_locator) }

    expect(created_rule.displayed?).to be true
  end


  after(:all) do
    @driver.quit
  end
end

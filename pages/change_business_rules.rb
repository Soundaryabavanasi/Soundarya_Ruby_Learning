
require 'selenium-webdriver'
require_relative 'locators'

class Changebusinessrules
  def initialize(driver)
    @driver = driver
  end

  # Navigate and create a Change Business Rule
  def create_change_business_rule(rule_name, group_name)
    # Click on "Business Rules"
    @driver.find_element(:xpath, "//a[contains(text(),'Business Rules')]").click
    
    # Choose "Change Business Rules"
    @driver.find_element(:xpath, "//a[contains(text(),'Change Business Rules')]").click

    # Click "New Rule"
    @driver.find_element(:xpath, "//button[contains(text(),'New Rule')]").click

    # Enter rule name
    @driver.find_element(:id, "rule_name").send_keys(rule_name)

    # Example condition: when a Change is created
    @driver.find_element(:id, "condition_field").click
    @driver.find_element(:xpath, "//option[contains(text(),'Change is created')]").click

    # Example action: assign to a group
    @driver.find_element(:id, "action_field").click
    @driver.find_element(:xpath, "//option[contains(text(),'Assign to Group')]").click
    @driver.find_element(:id, "group_select").send_keys(group_name)

    # Save the rule
    @driver.find_element(:id, "save_button").click
  end
end

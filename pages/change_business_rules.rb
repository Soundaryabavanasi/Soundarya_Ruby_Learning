require 'selenium-webdriver'

class ChangeBusinessRules
  include Locators

  def initialize(driver)
    @driver = driver
    @wait   = Selenium::WebDriver::Wait.new(timeout: 10) # define here once
  end

  def create_change_business_rule
    # Click Admin
    btn = @wait.until { @driver.find_element(:xpath, ADMIN_BTN) }
    @driver.execute_script("arguments[0].scrollIntoView(true);", btn)
    @driver.execute_script("arguments[0].click();", btn)
    sleep 2

    # Switch workspace if needed
    current_workspace = @wait.until do
      @driver.find_element(:css, '#admin-page-header .ws-name.ellipsis')
    end.text.strip

    puts "Current workspace: #{current_workspace}"

    if current_workspace == "Global Settings"
      puts "Switching to first available workspace..."

      @wait.until { @driver.find_element(:xpath, WORKSPACE_SWITCHER) }.click
      sleep 1

      first_workspace = @wait.until do
        @driver.find_element(:css, 'div#created-workspaces div.active-workspaces a:not(.selected-ws)')
      end
      first_workspace_name = first_workspace.attribute('data-name')
      first_workspace.click

      puts "Switched to workspace: #{first_workspace_name}"
    else
      puts "Already in workspace: #{current_workspace}. No switch needed."
    end

    # Go to Business Rules → Change
    @wait.until { @driver.find_element(:css, "a[href='/ws/2/admin/business_rules']") }.click
    @wait.until {@driver.find_element(:css, "a.btn.btn-primary.dropdown-toggle")}.click
    @wait.until{ @driver.find_element(:xpath, "//ul[@class='dropdown-menu br-rule-new-menu']//a[contains(@href,'change_business_rules')]")}.click
     
  end



  def fill_change_business_rule_form(rule_name:, description:)
  # Rule Name
  rule_name_field = @wait.until { @driver.find_element(:id, "rule-name") }
  rule_name_field.clear
  rule_name_field.send_keys(rule_name)

  # Description
  @driver.find_element(:id, "add-desc").click
  desc_field = @wait.until { @driver.find_element(:id, "rule-desc") }
  desc_field.send_keys(description)

  # Applies To → Agents
  applies_dropdown = @driver.find_element(:css, "div.select2-container.applicable_for a.select2-choice")
  @driver.execute_script("arguments[0].click();", applies_dropdown)
  @wait.until { @driver.find_element(:xpath, "//div[@class='select2-drop']//div[text()='Agents']") }.click

  # Execute On → New Form
  execute_dropdown = @driver.find_element(:css, "div.select2-container.applies_for a.select2-choice")
  @driver.execute_script("arguments[0].click();", execute_dropdown)
  @wait.until { @driver.find_element(:xpath, "//div[@class='select2-drop']//div[text()='New Form']") }.click

  # ---------- CONDITIONS ----------
  @driver.find_element(:id, "businessrule_filter_btn").click
  # Wait for first condition row (freshservice renders dropdowns inside .filter-list)
  field_dropdown = @wait.until { @driver.find_element(:css, "div.filter-list .filter-component select.field") }
  Selenium::WebDriver::Support::Select.new(field_dropdown).select_by(:text, "Impact")

  operator_dropdown = @driver.find_element(:css, "div.filter-list .filter-component select.operator")
  Selenium::WebDriver::Support::Select.new(operator_dropdown).select_by(:text, "is")

  value_dropdown = @driver.find_element(:css, "div.filter-list .filter-component select.value")
  Selenium::WebDriver::Support::Select.new(value_dropdown).select_by(:text, "High")

  # ---------- ACTIONS ----------
  @driver.find_element(:id, "businessrule_action_btn").click
  # Wait for first action row
  action_field_dropdown = @wait.until { @driver.find_element(:css, "div#businessrule_action .filter-component select.field") }
  Selenium::WebDriver::Support::Select.new(action_field_dropdown).select_by(:text, "Rollout Plan")

  action_operator_dropdown = @driver.find_element(:css, "div#businessrule_action .filter-component select.operator")
  Selenium::WebDriver::Support::Select.new(action_operator_dropdown).select_by(:text, "Make Mandatory")

  # ---------- SAVE ----------
  save_btn = @driver.find_element(:xpath, "//button[contains(.,'Save')]")
  @driver.execute_script("arguments[0].click();", save_btn)

  puts "Business Rule '#{rule_name}' created successfully!"
end



end

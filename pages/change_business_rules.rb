require 'selenium-webdriver'

class ChangeBusinessRules
  include Locators

  def initialize(driver)
    @driver = driver
    @wait   = Selenium::WebDriver::Wait.new(timeout: 10) # define here once
  end

  def create_change_business_rule(field_name)
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
  
  # Step 1: Click "Add new condition" link
  add_condition_link = @wait.until do
    el = @driver.find_element(:id, "businessrule_filter_btn")
    el if el.displayed? && el.enabled?
  end
  @driver.execute_script("arguments[0].scrollIntoView(true);", add_condition_link)
  add_condition_link.click
  puts "Clicked 'Add new condition'"

  # Step 2: Wait for the dropdown/options to appear and select "Change Forms"
  change_forms_option = @wait.until do
    el = @driver.find_element(:xpath, "//div[contains(@class,'select2-drop')]//div[text()='Change Forms']")
    el if el.displayed? && el.enabled?
  end
  change_forms_option.click
  puts "Selected 'Change Forms' option"

  # Select a field from Change Forms dropdown
  # Wait for the visible dropdown

  dropdown = @wait.until do
    el = @driver.find_element(:css, "div.filter-dropdown[style*='display: block']")
    el if el.displayed?
  end

  # Locate the field
  field_li = @wait.until do
    el = dropdown.find_element(:xpath, ".//li[text()='#{field_name}']")
    el if el.displayed? && el.enabled?
  end

  @driver.execute_script("arguments[0].scrollIntoView(true);", field_li)
  field_li.click
  puts "Selected field: #{field_name}"

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

# Make Custom Fields Mandatory

def create_business_rule_mandatory_custom_fields(rule_name, description, custom_fields)
  # Fill name and description
  @wait.until { @driver.find_element(:id, "rule_name") }.send_keys(rule_name)
  @driver.find_element(:id, "rule_description").send_keys(description)

  # Click "Add new condition"
  add_condition_btn = @wait.until { @driver.find_element(:id, "businessrule_filter_btn") }
  add_condition_btn.click
  puts "Clicked 'Add new condition'"

  # Select 'Change Forms'
  change_forms_option = @wait.until { @driver.find_element(:xpath, "//div[contains(@class,'select2-drop')]//div[text()='Change Forms']") }
  change_forms_option.click
  puts "Selected 'Change Forms'"

  # Select each custom field dynamically
  custom_fields.each do |field|
    select_field_from_change_forms(field)
    # Optionally mark as mandatory by clicking the checkbox/icon if available
    mandatory_checkbox = @wait.until { 
      @driver.find_element(:xpath, "//li[text()='#{field}']/following-sibling::li//input[@type='checkbox']") rescue nil
    }
    if mandatory_checkbox
      mandatory_checkbox.click
      puts "Marked '#{field}' as mandatory"
    end
  end

  # Save the Business Rule
  save_btn = @wait.until { @driver.find_element(:id, "PropsSubmitBtn") }
  @driver.execute_script("arguments[0].scrollIntoView(true);", save_btn)
  save_btn.click
  puts "Business Rule '#{rule_name}' created successfully"
end


end

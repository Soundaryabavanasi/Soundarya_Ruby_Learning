require 'selenium-webdriver'
require_relative 'locators'

class AdminPage
  include Locators

  def initialize(driver)
    @driver = driver
    @wait = Selenium::WebDriver::Wait.new(timeout: 15)
  end

  def open_admin
    btn = @wait.until { @driver.find_element(:xpath, ADMIN_BTN) }
    @driver.execute_script("arguments[0].scrollIntoView(true);", btn)
    @driver.execute_script("arguments[0].click();", btn)
    sleep 2
  end

  
## switching to local workspace if current workspace is in global
  def switch_from_global_to_first_workspace
  # Get the current workspace text without clicking
  current_workspace = @wait.until { 
    @driver.find_element(:css, '#admin-page-header .ws-name.ellipsis')
  }.text.strip

  puts "Current workspace: #{current_workspace}"

  # Only switch if current workspace is "Global Settings"
  if current_workspace == "Global Settings"
    puts "Current workspace is Global Settings. Switching to first available workspace..."

    ## click on the button
     @wait.until { @driver.find_element(:xpath, WORKSPACE_SWITCHER) }.click
    sleep 1

    ## get the list
    first_workspace = @wait.until { 
      @driver.find_element(:css, 'div#created-workspaces div.active-workspaces a:not(.selected-ws)') 
    }
    first_workspace_name = first_workspace.attribute('data-name')
    first_workspace.click

    puts "Switched to workspace: #{first_workspace_name}"
  else
    puts "Already in workspace: #{current_workspace}. No switch needed."
  end
end





  def open_field_manager
    @wait.until { @driver.find_element(:xpath, FIELD_MANAGER) }.click
    puts "Field Manager opened successfully"
    sleep 2
  end

  def click_change_fields
    @wait.until { @driver.find_element(:xpath, CHANGE_FIELDS_BTN) }.click
    puts "Change Fields clicked"
  end

  def click_text_field
  field_list = @wait.until {
    @driver.find_element(:id, 'custom-fields')
  }
  # Find the Text field (data-type="text")
  text_field = field_list.find_element(:css, 'li[data-type="text"] span')
# Click the field
  text_field.click
  sleep 2
  # Wait for the input field to appear
  field_input = @wait.until { @driver.find_element(:xpath, CHANGE_CUSTOM_TEXT_LABEL) }
  # Clear existing value and send new value
  field_input.clear
  field_input.send_keys("Text Custom field")
  puts "Value added to the field"

  sleep 10
end

def click_done_button
  # Wait for the Done button to be visible and clickable
  done_button = @wait.until {
    @driver.find_element(:id, 'PropsSubmitBtn')
  }

  # Click the Done button
  done_button.click
  puts "Done button clicked"
end

end


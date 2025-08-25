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
  text_field = field_list.find_element(:css, CHANGE_FIELD_LABEL_VALUE)
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
  # Wait for the modal itself to be visible
  @wait.until { @driver.find_element(:id, "CustomPropsModal").displayed? }

  # Ensure the footer and button are present
  done_button = @wait.until do
    btn = @driver.find_element(:id, "PropsSubmitBtn")
    btn if btn.displayed? && btn.enabled?
  end

  # Scroll into view (sometimes needed inside modals)
  @driver.execute_script("arguments[0].scrollIntoView(true);", done_button)

  # Debug: print state
  puts "Displayed? #{done_button.displayed?}, Enabled? #{done_button.enabled?}, Value: #{done_button.attribute("value")}"

  # Trigger a real DOM click event
  @driver.execute_script(<<~JS, done_button)
    arguments[0].dispatchEvent(new MouseEvent('click', {
      bubbles: true, cancelable: true, view: window
    }));
  JS

  puts "Done button clicked"
end
sleep 10

# save form
def save_form
  @driver.switch_to.default_content
  wait = Selenium::WebDriver::Wait.new(timeout: 15)

  save_button = wait.until { @driver.find_element(:id, "save_itil_fields") }
  @driver.execute_script("arguments[0].click();", save_button)
end

end


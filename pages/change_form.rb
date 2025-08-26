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

  # Switching to local workspace if current workspace is global
  def switch_from_global_to_first_workspace
    current_workspace = @wait.until { 
      @driver.find_element(:css, '#admin-page-header .ws-name.ellipsis')
    }.text.strip

    puts "Current workspace: #{current_workspace}"

    if current_workspace == "Global Settings"
      puts "Switching to first available workspace..."
      @wait.until { @driver.find_element(:xpath, WORKSPACE_SWITCHER) }.click
      sleep 1

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

  # Creating two custom fields under planning fields
  def add_two_custom_fields_and_done
    2.times do |i|
      # Step 1: Click "Add new field"
      add_field_li = @wait.until do
        el = @driver.find_element(:css, "li.field.new-planning-field span.tooltip")
        el if el.text.strip == "Add new field" && el.displayed?
      end
      add_field_li.click
      puts "Clicked 'Add new field' ##{i + 1}"

      # Step 2: Wait for input field to appear
      field_input = @wait.until do
        el = @driver.find_element(:css, "input[name='custom-label']")
        el if el.displayed? && el.enabled?
      end

      # Step 3: Enter unique value
      field_input.clear
      field_input.send_keys("CustomField_#{Time.now.to_i}_#{i}")
      puts "Entered value for field ##{i + 1}"

      # Step 4: Click the Done button (your actual Done button)
      done_button = @wait.until do
        el = @driver.find_element(:id, "PropsSubmitBtn")
        el if el.displayed? && el.enabled?
      end
      @driver.execute_script("arguments[0].scrollIntoView(true);", done_button)
      @driver.execute_script("arguments[0].click();", done_button)
      puts "Clicked Done for field ##{i + 1}"

      sleep 1
    end
  end

  def click_input_save_button
    puts "⏳ Waiting for <input Save> button..."
    save_input = @wait.until do
      el = @driver.find_element(:css, "input.save-custom-form.btn.btn-primary")
      el if el.displayed?
    end

    puts "Found input Save button: value='#{save_input.attribute("value")}'"
    @driver.execute_script("arguments[0].scrollIntoView(true);", save_input)
    @driver.execute_script("arguments[0].click();", save_input)
    puts "Input Save button clicked"

    # Handle confirm popup if it appears
    begin
      confirm_wait = Selenium::WebDriver::Wait.new(timeout: 5)
      confirm_btn = confirm_wait.until do
        el = @driver.find_element(:id, "confirm_popup_for_tkt-submit")
        el if el.displayed?
      end
      puts "Confirm popup appeared. Clicking confirm..."
      @driver.execute_script("arguments[0].click();", confirm_btn)
      puts "Confirm button clicked"
    rescue Selenium::WebDriver::Error::TimeoutError
      puts "ℹ No confirm popup appeared. Skipping..."
    end
  end

  def go_back_workspace
    field_manager_link = @wait.until do
      el = @driver.find_element(:css, "a.settings-page-link")
      el if el.displayed?
    end

    @driver.execute_script("arguments[0].scrollIntoView(true);", field_manager_link)
    field_manager_link.click
    puts "Clicked Field Manager link successfully"
  end
end

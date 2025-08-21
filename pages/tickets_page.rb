require 'selenium-webdriver'
require_relative 'locators'

class TicketPage
  include Locators

  def initialize(driver)
    @driver = driver
    @wait = Selenium::WebDriver::Wait.new(timeout: 15)
  end

  def open_new_ticket_form
    @wait.until { @driver.find_element(:css, TICKET_PLUS_ICON) }.click
    @wait.until { @driver.find_element(:xpath, TICKET_OPTION) }.click
    @wait.until { @driver.find_element(:css, TICKET_SUBJECT_FIELD) }
  end

  def select_workspace(workspace_name)
    return unless workspace_name

    @wait.until { @driver.find_element(:xpath, WORKSPACE_DROPDOWN) }.click
    sleep 1
    @wait.until {
      @driver.find_element(:xpath, WORKSPACE_OPTION % workspace_name)
    }.click
    sleep 2
  end

  def fill_requester(requester)
    field = @wait.until { @driver.find_element(:xpath, REQUESTER_FIELD) }
    field.send_keys(requester)
    sleep 1
    field.send_keys(:enter)
  end

  def fill_subject(subject)
    field = @wait.until { @driver.find_element(:css, TICKET_SUBJECT_FIELD) }
    field.send_keys(subject)
  end

  def fill_ticket_description(description)
    editor = @wait.until { @driver.find_element(:css, TICKET_DESCRIPTION) }
    @driver.execute_script("arguments[0].scrollIntoView(true);", editor)
    editor.click
    editor.send_keys(description)
  end

  def create_ticket(requester, subject, description, workspace_name=nil)
    select_workspace(workspace_name) if workspace_name
    fill_requester(requester)
    fill_subject(subject)
    fill_ticket_description(description)
    @wait.until { @driver.find_element(:css, SAVE_BUTTON) }.click
    sleep 5
  end

  def click_update_button
    btn = @wait.until { @driver.find_element(:css, UPDATE_BUTTON) }
    @driver.execute_script("arguments[0].scrollIntoView(true);", btn)
    btn.click
  end

  def ticket_status
    @wait.until { @driver.find_element(:xpath, STATUS_DROPDOWN) }.text.strip
  end
end

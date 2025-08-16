require 'selenium-webdriver'

class TicketPage
  def initialize(driver)
    @driver = driver
    @wait = Selenium::WebDriver::Wait.new(timeout: 15)
  end

  def open_new_ticket_form
    plus_icon = @wait.until { @driver.find_element(:css, 'svg#add-new-icon[aria-label="Add New"]') }
    plus_icon.click

    ticket_option = @wait.until {
      @driver.find_element(:xpath, "//div[@class='nav_new_details esm']/span[text()='Ticket']/ancestor::a")
    }
    ticket_option.click

    @wait.until { @driver.find_element(:css, "input[name='ticket[subject]']") }
  end

  def fill_ticket_description(description)
    editor = @wait.until { @driver.find_element(:css, "div.fr-element.fr-view[contenteditable='true']") }
    @driver.execute_script("arguments[0].scrollIntoView(true);", editor)
    editor.click
    editor.send_keys(description)
  end

  def create_ticket(requester, subject, description)
    requester_field = @wait.until {
      @driver.find_element(:xpath, "//input[contains(@class,'ember-power-select-search-input') and @placeholder='Search']")
    }
    requester_field.send_keys(requester)
    sleep 1
    requester_field.send_keys(:enter)

    subject_field = @wait.until { @driver.find_element(:css, "input[name='ticket[subject]']") }
    subject_field.send_keys(subject)

    fill_ticket_description(description)

    save_button = @wait.until { @driver.find_element(:css, "button[type='submit']") }
    save_button.click

    sleep 5
  end

  def ticket_exists?(expected_subject)
    subject_element = @wait.until {
      @driver.find_element(:css, "input[name='ticket[subject]'], h1.ticket-subject")
    }
    subject_element.attribute('value') == expected_subject || subject_element.text == expected_subject
  rescue Selenium::WebDriver::Error::TimeoutError
    false
  end

  # ✅ Update ticket status (select dropdown option only)
  def update_ticket_status(new_status)
    status_dropdown = @wait.until {
      @driver.find_element(:css, "div[formserv-field-name='status'] div.ember-power-select-trigger")
    }
    status_dropdown.click

    option = @wait.until {
      @driver.find_element(:xpath, "//li[contains(@class,'ember-power-select-option')][normalize-space(text())='#{new_status}']")
    }
    option.click
  end

  # ✅ Click the Update button
  def click_update_button
    update_btn = @wait.until { @driver.find_element(:id, "form-submit") }
    @wait.until { update_btn.enabled? }
    @driver.execute_script("arguments[0].scrollIntoView(true);", update_btn)
    begin
      update_btn.click
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      puts "⚠️ JS click fallback"
      @driver.execute_script("arguments[0].click();", update_btn)
    end
    puts "Clicked on Update button"
  end

  sleep 10
  # ✅ Read current ticket status
  def ticket_status
    status_element = @wait.until {
      @driver.find_element(:css, "div[formserv-field-name='status'] div.ember-power-select-trigger")
    }
    status_element.text.strip
  end

  def validate_ticket_landing_page
    new_ticket_btn = @wait.until { @driver.find_element(:css, "button[title='New Ticket']") }
    raise "New Ticket button not found — likely not on ticket landing page" unless new_ticket_btn.displayed?

    ticket_list = @driver.find_elements(:css, ".ticket-list-item")
    raise "No tickets found or not on ticket page" if ticket_list.empty?
  end
end

require 'selenium-webdriver'

class TicketPage
  def initialize(driver)
    @driver = driver
    @new_ticket_button = { css: '.new-ticket-btn' }
    @subject_field = { id: 'ticket_subject' }
    @description_field = { id: 'ticket_description' }
    @submit_ticket_button = { css: '.submit-ticket-btn' }
    @ticket_list = { css: '.ticket-list' }
    @status_dropdown = { css: '.ticket-status' }
    @save_status_button = { css: '.save-status' }
  end

  def open_new_ticket_form
    @driver.find_element(@new_ticket_button).click
  end

  def create_ticket(subject, description)
    @driver.find_element(@subject_field).send_keys(subject)
    @driver.find_element(@description_field).send_keys(description)
    @driver.find_element(@submit_ticket_button).click
  end

  def ticket_exists?(subject)
    @driver.find_element(@ticket_list).text.include?(subject)
  end

  def update_ticket_status(status)
    dropdown = @driver.find_element(@status_dropdown)
    Selenium::WebDriver::Support::Select.new(dropdown).select_by(:text, status)
    @driver.find_element(@save_status_button).click
  end

  def ticket_status
    @driver.find_element(@status_dropdown).text
  end
end

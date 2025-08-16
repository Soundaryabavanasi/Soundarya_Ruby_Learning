require 'selenium-webdriver'
require 'rspec'
require_relative '../pages/login'
require_relative '../pages/tickets_page'
require_relative '../pages/admin_page'
require 'securerandom'

RSpec.describe 'Freshservice Ticket Flow' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 5
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)

    @login_page = LoginPage.new(@driver)
    @ticket_page = TicketPage.new(@driver)

    @login_page.open(ENV['FRESHSERVICE_URL'])
    @login_page.login(ENV['FRESHSERVICE_EMAIL'], ENV['FRESHSERVICE_PASSWORD'])
    sleep 3 # TODO: Replace with explicit wait for login success
  end

  it 'creates, verifies, updates, and confirms a ticket' do
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    random_str = SecureRandom.hex(4)

    subject     = "Test Subject #{timestamp}-#{random_str}"
    description = "This is a test description #{timestamp}-#{random_str}"
    requester   = "bhavanasi.ramalinga1@freshworks.com"

    # Create ticket
    @ticket_page.open_new_ticket_form
    sleep 2
    @ticket_page.create_ticket(requester, subject, description)
    sleep 2

    # Open status dropdown
    status_dropdown = @wait.until {
      @driver.find_element(:css, "div[formserv-field-name='status'] div.ember-power-select-trigger")
    }
    status_dropdown.click

    # Wait for options to appear
    options = @wait.until {
      elems = @driver.find_elements(:css, "li.ember-power-select-option")
      elems unless elems.empty?
    }

    puts "Available options: " + options.map(&:text).join(", ")

    # Select Pending
    pending_option = options.find { |opt| opt.text.strip == "Pending" }
    raise "Pending option not found!" unless pending_option
    pending_option.click

    sleep 2

    # Click Update button (must be inside this `it` block)
    @ticket_page.click_update_button
  
    sleep 10
    # Verify status updated
    expect(@ticket_page.ticket_status).to eq('Pending')
  end

  after(:all) do
    @driver.quit
  end
end

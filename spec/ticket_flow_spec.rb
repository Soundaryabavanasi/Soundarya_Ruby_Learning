require 'selenium-webdriver'
require 'rspec'
require_relative '../pages/login'
require_relative '../pages/ticket_page'
require_relative '../pages/admin_page'
require 'securerandom'

RSpec.describe 'Freshservice Ticket Flow' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)

    @login_page = LoginPage.new(@driver)
    @ticket_page = TicketPage.new(@driver)
    @admin_page  = AdminPage.new(@driver)

    @login_page.open(ENV['FRESHSERVICE_URL'])
    @login_page.login(ENV['FRESHSERVICE_EMAIL'], ENV['FRESHSERVICE_PASSWORD'])
    sleep 3
  end

  it 'creates, verifies, updates, and confirms a ticket' do
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    random_str = SecureRandom.hex(4)

    subject   = "Test Subject #{timestamp}-#{random_str}"
    description = "This is a test description #{timestamp}-#{random_str}"
    requester = "bhavanasi.ramalinga1@freshworks.com"
    workspace_name = "IT"

    @ticket_page.open_new_ticket_form
    sleep 2
    @ticket_page.create_ticket(requester, subject, description, workspace_name)

    # Update ticket status to Pending
    @wait.until { @driver.find_element(:xpath, Locators::STATUS_DROPDOWN) }.click
    options = @wait.until { @driver.find_elements(:xpath, Locators::STATUS_OPTION % "Pending") }
    options.first.click

    sleep 2
    @ticket_page.click_update_button
    sleep 2

    expect(@ticket_page.ticket_status).to eq('Pending')
  end


  after(:all) do
    @driver.quit
  end
end

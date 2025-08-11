require 'selenium-webdriver'
require 'rspec'
require 'bundler/setup'
require 'dotenv/load'
require_relative '../pages/login_page'
require_relative '../pages/ticket_page'

RSpec.describe 'Freshservice Ticket Flow' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @login_page = LoginPage.new(@driver)
    @ticket_page = TicketPage.new(@driver)

    @login_page.open
    @login_page.login(ENV['FRESHSERVICE_EMAIL'], ENV['FRESHSERVICE_PASSWORD'])
    sleep 3 # Replace with proper wait
  end

  it 'creates, verifies, updates, and confirms a ticket' do
    subject = "Test Ticket #{Time.now.to_i}"
    description = "This is an automated test ticket."

    # Create a new ticket
    @ticket_page.open_new_ticket_form
    @ticket_page.create_ticket(subject, description)
    sleep 2 # Replace with proper wait

    # Verify ticket appears
    expect(@ticket_page.ticket_exists?(subject)).to be true

    # Update ticket status
    @ticket_page.update_ticket_status('Resolved')
    sleep 2 # Replace with proper wait

    # Verify status updated
    expect(@ticket_page.ticket_status).to eq('Resolved')
  end

  after(:all) do
    @driver.quit
  end
end

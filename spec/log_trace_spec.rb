require 'selenium-webdriver'
require 'rspec'
require 'logger'

RSpec.describe 'Demo Form Submission' do
  before(:all) do
    # Create logger writing to file 'test_steps.log'
    @logger = Logger.new('logsteps.log')
    @logger.level = Logger::INFO

    @logger.info("Starting test suite")

    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
  end

  after(:all) do
    @driver.quit if @driver
    @logger.info("Test suite finished")
    @logger.close
  end

  before(:each) do |example|
    @logger.info("Starting test: #{example.full_description}")
  end

  after(:each) do |example|
    if example.exception
      timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
      screenshot_name = "screenshot-#{example.description.gsub(' ', '_')}-#{timestamp}.png"
      @driver.save_screenshot(screenshot_name)
      @logger.error("Test failed: #{example.full_description}")
      @logger.error("Screenshot saved to #{screenshot_name}")
    else
      @logger.info("Test passed: #{example.full_description}")
    end
  end

  def log_step(step_description)
    @logger.info("STEP: #{step_description}")
  end

  fit 'submits form successfully and validates output' do
    @driver.navigate.to 'https://demoqa.com/text-box'
    log_step("Navigated to form page")

    @driver.find_element(:id, 'userName').send_keys('Soundarya')
    log_step("Entered Name")

    @driver.find_element(:id, 'userEmail').send_keys('soundarya@example.com')
    log_step("Entered Email")

    @driver.find_element(:id, 'currentAddress').send_keys('Kadapa')
    log_step("Entered Current Address")

    @driver.find_element(:id, 'permanentAddress').send_keys('Hyderabad')
    log_step("Entered Permanent Address")

    @driver.find_element(:id, 'submit').click
    log_step("Clicked Submit")

    output_name = @driver.find_element(:id, 'name').text
    expect(output_name).to include('Soundarya')
    log_step("Verified Name in output")

    output_email = @driver.find_element(:id, 'email').text
    expect(output_email).to include('soundarya@example.com')
    log_step("Verified Email in output")
  end

  it 'shows validation error for invalid email' do
    @driver.navigate.to 'https://demoqa.com/text-box'
    log_step("Navigated to form page")

    @driver.find_element(:id, 'userName').send_keys('Soundarya')
    log_step("Entered Name")

    @driver.find_element(:id, 'userEmail').send_keys('invalid-email')
    log_step("Entered invalid Email")

    @driver.find_element(:id, 'currentAddress').send_keys('Kadapa')
    log_step("Entered Current Address")

    @driver.find_element(:id, 'permanentAddress').send_keys('Hyderabad')
    log_step("Entered Permanent Address")

    @driver.find_element(:id, 'submit').click
    log_step("Clicked Submit")

    output = @driver.find_element(:id, 'output').text
    expect(output).not_to include('invalid-email')
    log_step("Verified invalid email is not accepted")
  end
end

require 'selenium-webdriver'
require 'rspec'
require 'logger'

RSpec.describe 'Demo Form Submission' do
  before(:all) do
    @logger = Logger.new('logsteps.log')
    @logger.level = Logger::INFO
    @logger.info("Starting test suite")

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--start-maximized')

    @driver = Selenium::WebDriver.for :chrome, options: options
    @wait = Selenium::WebDriver::Wait.new(timeout: 10) # explicit wait
  end

  after(:all) do
    sleep 3 # keep browser open briefly after tests
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

  def hide_ads
    begin
      ad = @driver.find_element(:id, 'adplus-anchor')
      @driver.execute_script("arguments[0].style.display = 'none';", ad)
      log_step("Hidden floating ad overlay")
    rescue Selenium::WebDriver::Error::NoSuchElementError
      # No ad found, continue
    end
  end

  def safe_click(element)
    @driver.execute_script("arguments[0].scrollIntoView(true);", element)
    sleep 0.5
    @driver.execute_script("arguments[0].click();", element)
  end

  fit 'submits form successfully and validates output' do
    @driver.navigate.to 'https://demoqa.com/text-box'
    @wait.until { @driver.find_element(:id, 'userName').displayed? }
    log_step("Navigated to form page")

    hide_ads

    @driver.find_element(:id, 'userName').send_keys('Soundarya')
    log_step("Entered Name")

    @driver.find_element(:id, 'userEmail').send_keys('soundarya@example.com')
    log_step("Entered Email")

    @driver.find_element(:id, 'currentAddress').send_keys('Kadapa')
    log_step("Entered Current Address")

    @driver.find_element(:id, 'permanentAddress').send_keys('Hyderabad')
    log_step("Entered Permanent Address")

    submit_btn = @driver.find_element(:id, 'submit')
    safe_click(submit_btn)
    log_step("Clicked Submit")

    @wait.until { @driver.find_element(:id, 'name').text.include?('Soundarya') }
    output_name = @driver.find_element(:id, 'name').text
    expect(output_name).to include('Soundarya')
    log_step("Verified Name in output")

    @wait.until { @driver.find_element(:id, 'email').text.include?('soundarya@example.com') }
    output_email = @driver.find_element(:id, 'email').text
    expect(output_email).to include('soundarya@example.com')
    log_step("Verified Email in output")
  end

  it 'shows validation error for invalid email' do
    @driver.navigate.to 'https://demoqa.com/text-box'
    @wait.until { @driver.find_element(:id, 'userName').displayed? }
    log_step("Navigated to form page")

    hide_ads

    @driver.find_element(:id, 'userName').send_keys('Soundarya')
    log_step("Entered Name")

    @driver.find_element(:id, 'userEmail').send_keys('invalid-email')
    log_step("Entered invalid Email")

    @driver.find_element(:id, 'currentAddress').send_keys('Kadapa')
    log_step("Entered Current Address")

    @driver.find_element(:id, 'permanentAddress').send_keys('Hyderabad')
    log_step("Entered Permanent Address")

    submit_btn = @driver.find_element(:id, 'submit')
    safe_click(submit_btn)
    log_step("Clicked Submit")

    output = @driver.find_element(:id, 'output').text
    expect(output).not_to include('invalid-email')
    log_step("Verified invalid email is not accepted")
  end
end

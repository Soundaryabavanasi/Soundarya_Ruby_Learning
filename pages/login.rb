class LoginPage
  def initialize(driver)
    @driver = driver
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
  end

  def open(url)
    @driver.get(url)
  end

  def login(email, password)
  # Find iframe that contains 'login' or 'sign in', not reCAPTCHA
  iframes = @driver.find_elements(:tag_name, 'iframe')

  login_iframe = iframes.find do |frame|
    frame_name = frame.attribute('name').to_s.downcase
    frame_src = frame.attribute('src').to_s.downcase
    frame_id   = frame.attribute('id').to_s.downcase

    (frame_name.include?('login') || frame_src.include?('login') || frame_id.include?('login')) &&
      !frame_src.include?('recaptcha')
  end

  # Switch to login iframe only if found
  if login_iframe
    puts "Switching to login iframe: #{login_iframe.attribute('name') || login_iframe.attribute('id')}"
    @driver.switch_to.frame(login_iframe)
  else
    puts "No specific login iframe found. Staying in main page."
  end

  # Wait for email field
  email_field = @wait.until do
    @driver.find_element(:css, 'input[type="email"], #user_session_email, #email')
  end
  email_field.clear
  email_field.send_keys(email)

  # Fill password
  password_field = @driver.find_element(:css, 'input[type="password"], #user_session_password, #password')
  password_field.clear
  password_field.send_keys(password)

  # Click login
  @driver.find_element(:css, 'input[type="submit"], button[type="submit"]').click

  # Switch back
  @driver.switch_to.default_content
end

end

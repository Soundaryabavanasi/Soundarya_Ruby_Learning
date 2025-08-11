# pages/login_page.rb
class LoginPage
  def initialize(driver)
    @driver = driver
  end

  # Locators
  def email_field
    @driver.find_element(id: 'user_email')
  end

  def password_field
    @driver.find_element(id: 'user_password')
  end

  def login_button
    @driver.find_element(name: 'commit')
  end

  # Actions
  def enter_email(email)
    email_field.send_keys(email)
  end

  def enter_password(password)
    password_field.send_keys(password)
  end

  def click_login
    login_button.click
  end
end

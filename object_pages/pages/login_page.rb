# pages/login_page.rb
class LoginPage
  def initialize(driver)
    @driver = driver
    @email_field = { id: 'email' }
    @password_field = { id: 'password' }
    @login_button = { css: 'button[type="submit"]' }
  end

  def visit(url)
    @driver.navigate.to(url)
  end

  def enter_email(email)
    @driver.find_element(@email_field).send_keys(email)
  end

  def enter_password(password)
    @driver.find_element(@password_field).send_keys(password)
  end

  def click_login
    @driver.find_element(@login_button).click
  end
end

require 'selenium-webdriver'

class LoginPage
  def initialize(driver)
    @driver = driver
    @email_field = { id: 'username' }        # Change to actual Freshservice email input locator
    @password_field = { id: 'password' }     # Change to actual Freshservice password input locator
    @login_button = { name: 'login' }        # Change to actual Freshservice login button locator
  end

  def open
    @driver.navigate.to "freshworkshelpdesk527-695210703739135957.myfreshworks.com"
  end

  def login(email, password)
    @driver.find_element(@email_field).send_keys(email)
    @driver.find_element(@password_field).send_keys(password)
    @driver.find_element(@login_button).click
  end
end

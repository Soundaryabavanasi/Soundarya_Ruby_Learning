require 'selenium-webdriver'

class AdminPage
  def initialize(driver)
    @driver = driver
    @wait = Selenium::WebDriver::Wait.new(timeout: 15)
  end

  # Navigate to Admin via sidebar dynamically
  def navigate_to_admin
    click_sidebar_item('Settings')
  end

  # Validate Admin page title
  def validate_title(expected_title)
    actual_title = @wait.until { @driver.find_element(css: 'h1') }.text.strip
    raise "Expected title '#{expected_title}', but got '#{actual_title}'" unless actual_title == expected_title
  end

  private

  # Generic sidebar click method
  def click_sidebar_item(item_text)
    element = @wait.until do
      @driver.find_elements(css: 'a.menu-tab').find do |el|
        el.text.strip.casecmp(item_text).zero?
      end
    end

    @driver.execute_script("arguments[0].scrollIntoView(true);", element)
    @driver.action.move_to(element).perform
    sleep 0.5
    element.click
  end
end

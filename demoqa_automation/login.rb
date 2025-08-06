require 'bundler/setup'
require 'selenium-webdriver'
require 'webdrivers'

puts "Starting automation..."

# Setup Chrome
driver = Selenium::WebDriver.for :chrome
puts "Chrome opened!"

# Open the demo page
driver.navigate.to "https://demoqa.com/text-box"
puts "Navigated to DemoQA"

# Fill the form fields
driver.find_element(:id, 'userName').send_keys('Soundarya')
driver.find_element(:id, 'userEmail').send_keys('soundarya@example.com')
driver.find_element(:id, 'currentAddress').send_keys('Kadapa, Andhra Pradesh')
driver.find_element(:id, 'permanentAddress').send_keys('Hyderabad')

# Optional: Remove iframes (ads)
driver.execute_script("document.querySelectorAll('iframe').forEach(el => el.remove());")

# Scroll and click the submit button
submit_btn = driver.find_element(:id, 'submit')
driver.execute_script("arguments[0].scrollIntoView(true);", submit_btn)
sleep 1
submit_btn.click

sleep 2  # See the result

driver.quit
puts "Test completed!"

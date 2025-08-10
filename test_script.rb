require 'bundler/setup'
require 'selenium-webdriver'
require 'webdrivers'

puts "🚀 Starting Locator Demo Script..."

# Setup Chrome browser
driver = Selenium::WebDriver.for :chrome
driver.manage.window.maximize

puts " Navigating to DemoQA Text Box Page..."
driver.navigate.to "https://demoqa.com/text-box"

# ID locator
puts "Using ID Locator..."
driver.find_element(:id, "userName").send_keys("Soundarya by ID")

# Name locator (NOTE: this input uses 'name' = fullName)
puts "Using Name Locator..."
driver.find_element(:name, "fullName").clear
driver.find_element(:name, "fullName").send_keys("Soundarya by Name")

# Class locator (NOTE: might not be unique)
puts " Using Class Locator..."
elements = driver.find_elements(:class, "form-control")
elements[2].send_keys("Kadapa using Class")  # currentAddress field

#  XPath locator
puts " Using XPath Locator..."
driver.find_element(:xpath, "//input[@id='userEmail']").send_keys("soundarya@example.com")

#  CSS Selector
puts " Using CSS Selector Locator..."
driver.find_element(:css, "textarea#permanentAddress").send_keys("Hyderabad using CSS")

# Link Text Locator
puts "🔗 Using Link Text Locator (on home page)..."
driver.navigate.to "https://demoqa.com"
driver.find_element(:link_text, "Elements").click

puts " Locator Demo Completed!"
sleep 2
driver.quit


## // → Search anywhere in the HTML

## input → Look for <input> tag

## [@id='userName'] → Find the one with id='userName'

## XPath = Look at every item in the house and check its color + legs

## CSS Selector = Go directly to chairs and check IDs, classes

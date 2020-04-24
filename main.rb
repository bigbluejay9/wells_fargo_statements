#!/usr/bin/env ruby
# Downloads your wells fargo statements. Because clicking on them is annoying.

require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://www.wellsfargo.com"

YEARS = (2014..2019)

puts "Please log into the Wells Fargo website."
puts "Then navigate to the 'Statement and Documents' page of the account you want to download."
puts "Will download statements in the following years: #{YEARS.to_a.to_s}"
puts "NOTE: Ensure that you have the application default for 'pdf' set to download!"
puts "In the Selenium Firefox instance, go to about:preferences -> Applications and ensure that"
puts "'Portable Document Format (PDF)' is set to 'Save File'"
puts "Continue? (yN)"

exit 1 if gets.chomp.upcase != "Y"

wait = Selenium::WebDriver::Wait.new(timeout: 10)
YEARS.each do |yr|
  wait.until { driver.find_element(:css,  "div._2kfOSIHU:nth-child(2) > div:nth-child(2) > div:nth-child(3)")}
  time_period_selector = driver.find_element(:css,  "div._2kfOSIHU:nth-child(2) > div:nth-child(2) > div:nth-child(3)")
  time_period_selector.click

  sleep(2)
  yrs = driver.find_element(:css,  "._2tmudMfd")
  y = yrs.find_element(:xpath, "//li[contains(text(), '#{yr}')]")
  driver.execute_script("arguments[0].click();", y)
  sleep(2)

  continue = true
  (4..15).each do |i|
    break unless continue
    begin
      btn = driver.find_element(:css, ".TEAtpSS1 > div:nth-child(#{i}) > div:nth-child(1) > div:nth-child(2) > button:nth-child(1)")
      btn.click
    rescue e
      puts "Rescued exception: #{e}"
      puts "Continue with this year? yN"
      if gets.chomp.upcase != "Y"
        continue = false
      end
    end
  end

  puts "Continue to next year (next year = #{yr + 1})? yN"
  exit if gets.chomp.upcase != "Y"
end

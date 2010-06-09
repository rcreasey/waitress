Given /^I request GET "([^\"]*)"$/ do |url|
  visit url
end

Given /^the following order$/ do |table|
  table.hashes.each do |order|
    Waitress.redis.set order[:mac_address], order[:node]
  end
end

Given /^the database is empty$/ do
  Waitress.redis.flushdb
end

When /^I POST the following order$/ do |table|
  order = table.hashes.first
  page.driver.post('/', { :mac_address => order[:mac_address], :node => order[:node] })
end

Then /^the database should not have a key for "([^\"]*)"$/ do |mac_address|
  Waitress.redis.exists( mac_address ) == false
end

Then /^the database should have a key for "([^\"]*)"$/ do |mac_address|
  Waitress.redis.exists( mac_address ) == true
end
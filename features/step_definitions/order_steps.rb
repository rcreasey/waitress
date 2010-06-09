Given /^I am viewing "(.+)"$/ do |url|
  visit(url)
end

Given /^the following paring$/ do |table|
  table.hashes.each do |pairing|
    Waitress.redis.set pairing[:mac_address], pairing[:node]
  end
end


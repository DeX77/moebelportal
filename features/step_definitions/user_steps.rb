Given /^the following users:$/ do |users|
  User.create!(users.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) user$/ do |pos|
  visit users_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following users:$/ do |expected_users_table|
  expected_users_table.diff!(tableish('table tr', 'td,th'))
end

Given /^I am not logged in$/ do
  visit logout_path
end


Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |username, password|
  visit login_path
  fill_in("login", :with => username)
  fill_in("pwd_", :with => password)
  click_button("Login")
end

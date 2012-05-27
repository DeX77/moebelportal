Given /^I am not logged in$/ do
  visit logout_path
end

Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |username, password|
  visit login_path
  fill_in("login", :with => username)
  fill_in("pwd_", :with => password)
  click_button("Login")
end

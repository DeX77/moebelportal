Given /^the following usergroups:$/ do |usergroups|
  Usergroup.create!(usergroups.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) usergroup$/ do |pos|
  visit usergroups_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following usergroups:$/ do |expected_usergroups_table|
  expected_usergroups_table.diff!(tableish('table tr', 'td,th'))
end

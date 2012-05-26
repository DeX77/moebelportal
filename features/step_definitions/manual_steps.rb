Given /^the following manuals:$/ do |manuals|
  Manual.create!(manuals.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) manual$/ do |pos|
  visit manuals_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following manuals:$/ do |expected_manuals_table|
  expected_manuals_table.diff!(tableish('table tr', 'td,th'))
end

Given /^the following tools:$/ do |tools|
  Tool.create!(tools.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) tool$/ do |pos|
  visit tools_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following tools:$/ do |expected_tools_table|
  expected_tools_table.diff!(tableish('table tr', 'td,th'))
end

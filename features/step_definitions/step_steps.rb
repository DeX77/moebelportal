Given /^the following steps:$/ do |steps|
  Step.create!(steps.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) step$/ do |pos|
  visit steps_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following steps:$/ do |expected_steps_table|
  expected_steps_table.diff!(tableish('table tr', 'td,th'))
end

Given /^the following materials:$/ do |materials|
  Material.create!(materials.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) material$/ do |pos|
  visit materials_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following materials:$/ do |expected_materials_table|
  expected_materials_table.diff!(tableish('table tr', 'td,th'))
end

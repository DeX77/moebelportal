Given /^the following products:$/ do |products|
  Product.create!(products.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) product$/ do |pos|
  visit products_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following products:$/ do |expected_products_table|
  expected_products_table.diff!(tableish('table tr', 'td,th'))
end

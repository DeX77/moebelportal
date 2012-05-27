Given /^there is no product named "([^"]*)"$/ do |product_name|
  base_locator = "http://moebelportal.topicmapslab.de"
  tm = RTM[base_locator]
  topicType = base_locator + "/types/product"
           
  products = tm.get(topicType).instances      
  product = products.select{  |x| x.occurrences.try(:first).try(:value) == product_name }.first unless products.blank?
  product.delete! unless product.blank?
end

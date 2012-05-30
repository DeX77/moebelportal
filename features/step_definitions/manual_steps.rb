Given /^there is no manual named "([^"]*)"$/ do |manual_name|
  base_locator = "http://moebelportal.topicmapslab.de"
  tm = RTM[base_locator]
  topicType = base_locator + "/types/manual"
           
  manuals = tm.get(topicType).instances      
  manual = manuals.select{  |x| x.occurrences.try(:first).try(:value) == manual_name }.first unless manuals.blank?
  manual.delete! unless manual.blank?
end

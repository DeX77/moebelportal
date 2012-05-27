Given /^there is no usergroup named "([^"]*)"$/ do |group_name|
  base_locator = "http://moebelportal.topicmapslab.de"
  tm = RTM[base_locator]
  topicType = base_locator + "/types/usergroup"       
  usergroups = tm.get(topicType).instances      
  group = usergroups.select{  |x| x.occurrences.try(:first).try(:value) == group_name }.first unless usergroups.blank?
  group.delete! unless group.blank?
end

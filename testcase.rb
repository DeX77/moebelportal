@base_locator = "http://moebelportal.topicmapslab.de"
@tm = RTM[@base_locator]

topic = @tm.topic_by_id(104)
puts "Name: " + topic["-"].first.value

tempTopic = @tm.get!("Blahub")
tempTopic["-"] = "was andres"
tempTopic["image"] = "lustiges Foto"
#tempTopic.add_type(@base_locator + "/types/product")
@tm.get(@base_locator + "/types/product").add_instance(tempTopic)

puts "Name: " + topic["-"].first.value
puts "Name: " + tempTopic["-"].first.value
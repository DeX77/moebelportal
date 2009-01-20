@base_locator = "http://moebelportal.topicmapslab.de"
@tm = RTM[@base_locator]

toptic65 = @tm.topic_by_id(65)
puts "Name: " + toptic65["-"].first.value

tempTopic = @tm.get!("Blahub")
tempTopic["name"] = "was andres"
tempTopic["image"] = "lustiges Foto"

puts "Name: " + toptic65["-"].first.value
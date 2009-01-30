require 'rtm/io/from_xtm2_libxml.rb'
dbFileName = "db/production.sqlite3"
puts "Gucken ob altes File da"
if (File.exists?(dbFileName))
  puts "File löschen"
  File.delete(dbFileName)
end
@base_locator = "http://moebelportal.topicmapslab.de"

puts "DB connect"
RTM.connect_sqlite3(dbFileName)
RTM.generate_database
@tm = RTM.from_xtm2(File.open("./Model/ikeatm.xtm2"), @base_locator)


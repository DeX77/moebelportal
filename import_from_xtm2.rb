dbFileName = File.dirname(__FILE__)+"../db/development.sqlite3"
puts "Gucken ob altes File da"
if (File.exists?(dbFileName))
  puts "File löschen"
  File.delete(dbFileName)
  File.new(dbFileName)
end
@base_locator = "http://moebelportal.topicmapslab.de"

puts "DB connect"
RTM.connect_sqlite3(dbFileName)
RTM.generate_database
@tm = RTM.from_xtm2lx(File.open("./Model/ikeatm.xtm2"), @base_locator)
if !(@tm)
  @tm = RTM.from_xtm2(File.open("./Model/ikeatm.xtm2"), @base_locator)
end
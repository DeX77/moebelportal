source :gemcutter

gem "rails", "~> 2.3.11"
gem "multi_json",  "~> 1.1.0"
gem "textile_editor_helper"
gem "rdoc",  "~> 2.4.2"

#C ruby
gem "sqlite3", "~> 1.3.6", :platforms => :ruby
gem "rtm-activerecord",  "=0.3.1", :platforms => :ruby

#jruby specific
gem "rtm-ontopia", "=0.3.1", :platforms => :jruby
gem "jdbc-sqlite3", :platforms => :jruby
gem "activerecord-jdbcsqlite3-adapter", :platforms => :jruby
gem "jruby-openssl", :platforms => :jruby

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
end

group :test do
  # bundler requires these gems while running tests
  gem "rcov"
end

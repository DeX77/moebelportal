source :gemcutter

gem "rails", "~> 2.3.11"
gem "multi_json",  "~> 1.1.0"
gem "textile_editor_helper"
gem "rdoc",  "~> 2.4.2"

#C ruby
gem "sqlite3", "~> 1.3.6", :platforms => :ruby
gem "rtm",  "=0.1.6"

#jruby specific
gem "jdbc-sqlite3", :platforms => :jruby
gem "activerecord-jdbcsqlite3-adapter", :platforms => :jruby
gem "jruby-openssl", :platforms => :jruby

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
end

group :test do
  # bundler requires these gems while running tests
  # rcov version 1.0 doesn't work with jruby
  gem "rcov", "=0.9.11"
  gem "capybara", "1.1.1"
  gem "cucumber", "1.1.0"
  gem "cucumber-rails", "0.3.2"
end

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
  gem "capybara", "0.3.9"
  gem "gherkin", "=2.4.1"
  gem "cucumber", "0.10.7"
  gem "cucumber-rails", "0.3.2"
  gem "spork"
  gem "database_cleaner" , ">= 0.5.0"
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

require 'capybara/rspec'
require 'capybara/rails'
Capybara.default_driver = :selenium_chrome
Capybara.server = :puma, { Silent: true } # To clean up your test output

abort("The Rails environment is running in production mode!") if Rails.env.production?
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include Capybara::DSL

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

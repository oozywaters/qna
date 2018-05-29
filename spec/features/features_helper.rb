require 'rails_helper'

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }

  Capybara.default_max_wait_time = 5
  Capybara.javascript_driver = :webkit
end

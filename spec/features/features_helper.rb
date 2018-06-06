require 'rails_helper'
require "selenium/webdriver"

Capybara.default_max_wait_time = 5
Capybara.server = :puma
Capybara.javascript_driver = :headless_chrome
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu) }
  )
  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end

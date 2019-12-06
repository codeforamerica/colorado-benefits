source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.3"

gem "administrate"
gem "administrate-field-enum"
gem "attr_encrypted"
gem "aws-sdk-s3", require: false
gem "bootsnap", ">= 1.1.0", require: false
gem "cfa-styleguide", git: "https://github.com/codeforamerica/cfa-styleguide-gem"
gem "chardinjs-rails"
gem "combine_pdf"
gem "delayed_job_active_record"
gem "delayed_job_web"
gem "devise"
gem "devise-otp",
  git: "https://github.com/pynixwang/devise-otp",
  ref: "a181217a2d436de7ebb9a278bcb326bbddefa514"
gem "geocoder"
gem "handlebars_assets"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "lograge"
gem "mixpanel-ruby"
gem "pdf-reader"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.12"
gem "rails", "~> 5.2.0"
gem "sass-rails", "~> 5.0"
gem "sentry-raven"
gem "slack-ruby-client"
gem "tooltipster-rails"
gem "twilio-ruby"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "rspec-rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
  # gem "wkhtmltopdf-binary-edge" # Uncomment to debug PDF styles locally
end

group :test do
  gem "axe-matchers"
  gem "capybara"
  gem "capybara-selenium"
  gem "climate_control"
  gem "launchy"
  gem "rspec_junit_formatter"
  gem "rubyzip", ">= 1.3.0"
  gem "timecop"
  gem "webdrivers", "~> 4.1"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

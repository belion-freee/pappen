ruby "2.5.0"
source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 5.1.1"
# Use Puma as the app server
gem "puma", "~> 3.7"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0.6"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
gem "therubyracer", platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use https://github.com/settingslogic/settingslogic
gem "settingslogic"
# Use jquery as the JavaScript library
gem "twitter", "< 6.2.0"
# Railsでlessを使えるようにする。Bootstrapがlessで書かれているため
gem "less-rails", git: "https://github.com/MustafaZain/less-rails"
# Bootstrapの本体
gem "execjs"
gem "twitter-bootstrap-rails"

gem "webpacker"

gem "line-bot-api"

gem "docomoru"

gem "kaminari"

gem "pg", "0.20.0"

# for security alert
gem "ffi", ">= 1.9.24"
gem "loofah", ">= 2.2.3"
gem "rubyzip", ">= 1.2.2"

gem "mechanize"

gem "devise"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"

  # use pry
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"

  # @see https://github.com/deivid-rodriguez/byebug/issues/289
  gem "rb-readline"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

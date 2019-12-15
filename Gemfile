source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails'
gem 'puma'
gem 'pg'
gem 'dotenv-rails'

group :development, :test do
  gem 'rspec-rails'
end

group :test, :development do
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'active_record-annotate'
end

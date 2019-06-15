source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0.rc1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'


group :development, :staging, :production do
  gem "passenger", "6.0.2"
end


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # for documentation
  gem 'yard'
  # For code styling and linting
  gem 'rubocop'
  # This can be used to empty tables in a database.
  gem "database_cleaner"
  # For writing tests
  gem "rspec-rails", "~> 3.8"
  # For generating swagger json from api integration test
  gem "rswag-specs"
  # For mocking external API requests
  gem "webmock"
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem "simplecov"
  gem "rspec-sidekiq"
  # For performance testing
  gem "rspec-benchmark"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# For fast and easy serialization of objects to json
gem "fast_jsonapi"

# generating fake data for filling in tables
gem "faker"

# For user authentication
# gem "devise"

# For easier queries on tags
gem "acts-as-taggable-array-on"

# For displaying api in swagger UI
gem "rswag-api"
gem "rswag-ui"

# For fast bulk uploads(inserting master sheet)
gem "activerecord-import"

# For background processes
gem "sidekiq"

# For making HTTP requests
gem "rest-client"

# For managing cors, allowing frontend to make calls
gem "rack-cors", require: "rack/cors"

# For pagination
gem "kaminari"

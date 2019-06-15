#!/bin/bash

echo "Setting up db for tests"
cd /var/app
ruby -v
service postgresql start
su -c "psql -c \"ALTER ROLE postgres WITH PASSWORD 'postgres';\"" postgres
# echo "Running rubocop"
# RAILS_ENV=test bundle exec pronto run -c=origin/develop --exit-code
RAILS_ENV=test rake db:setup
echo "Running tests"
echo "Verify swagger specs is properly generated"
# Generate swagger docs
bundle exec rake rswag:specs:swaggerize
echo "Running rspec"
RAILS_ENV=test bundle exec rspec

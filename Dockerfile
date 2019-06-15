FROM ruby:2.6.2-stretch

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client: In case you want to talk directly to postgres

RUN apt-get update && \
    apt-get install -y --force-yes apt-transport-https curl wget

# Install New Relic
# RUN echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list
# RUN curl https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && apt-get install -qq -y --force-yes --fix-missing --no-install-recommends \
    build-essential cmake libpq-dev postgresql postgresql-contrib supervisor git ghostscript file && \
    rm -rf /var/lib/apt/lists/*
# For installing new version of nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -qq -y nodejs
RUN npm install -g yarn

# Update ca certs
RUN update-ca-certificates

##############################################################################
# Configure New Relic
##############################################################################

# RUN nrsysmond-config --set license_key=0cb398c5c6a7d3c103a7c56335f63d1b7cbbd143

##############################################################################
# Configure supervisord
##############################################################################

RUN useradd supervisor -s /bin/false
RUN mkdir -p /var/log/supervisord
RUN mkdir -p /var/cache/supervisord
RUN chown -R supervisor:supervisor /var/log/supervisord
RUN chown -R supervisor:supervisor /var/cache/supervisord

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV APP_HOME /var/app
RUN mkdir -p $APP_HOME

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $APP_HOME

# Install CloudSQL Proxy
# RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
# RUN chmod +x cloud_sql_proxy

# install bundler
RUN gem install bundler

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy into the docker image directory from host OS directory.
COPY . .


# Compile assets
#RUN bundle exec rake assets:precompile

# Build react and move to public
RUN npm install --unsafe-perm

RUN chmod +x /var/app/deploy/run-server.sh

##############################################################################
# Run start.sh script when the container starts.
# Note: If you run migrations etc outside CMD, envs won't be available!
# This is not run on docker build but on docker run
##############################################################################
ENTRYPOINT ["/var/app/deploy/run-server.sh"]

EXPOSE 8080

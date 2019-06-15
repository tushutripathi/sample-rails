require "sidekiq"
# require "sidekiq/web"

Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 2
  config.redis = {url: ENV['REDIS_URL'], network_timeout: 2}
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 2 }
end

# Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
#   [user, password] == %w[tushar tushar123]
# end

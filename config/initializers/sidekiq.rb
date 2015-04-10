# This file is overwritten on deploy

url = if ENV['REDIS_1_PORT_6379_TCP_ADDR'].present?
    address = ENV['REDIS_1_PORT_6379_TCP_ADDR']
    port = ENV['REDIS_1_PORT_6379_TCP_PORT']
    "redis://#{address}:#{port}"
  else
    "redis://localhost:6379"
  end

Sidekiq.configure_client do |config|
  config.redis = { url: url, namespace: "signon" }
end
Sidekiq.configure_server do |config|
  config.redis = { url: url, namespace: "signon" }
end

Groups::Application.configure do
  config.eager_load = false # Rails 4 option
  
  config.cache_classes = false

  # Concert full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise an error if an email fails to be sent.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true
  
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
end
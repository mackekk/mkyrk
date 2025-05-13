require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mkyrk
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Internationalization configuration
    config.i18n.available_locales = [ :sv, :en ]
    config.i18n.default_locale = :sv
    config.i18n.fallbacks = [ :en ]

    # PROBLEM:
    # - Rails' content negotiation strictly matches Accept headers against supported formats
    # - Chrome DevTools mobile emulation sends Accept headers with application/xhtml+xml
    # - This causes 406 Not Acceptable errors when controllers only define respond_to format.html
    #
    # SOLUTION:
    # - Register our custom middleware early in the stack to modify problematic Accept headers
    # - This provides a global solution instead of modifying every controller
    # Add custom middleware for handling content negotiation
    config.middleware.insert_before ActionDispatch::Static, Middleware::ContentNegotiationMiddleware
  end
end

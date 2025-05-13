class ApplicationController < ActionController::Base
  # PROBLEM:
  # - The allow_browser versions: :modern setting restricts browser support based on features
  # - Chrome DevTools mobile emulation was being rejected as an unsupported browser
  # - This contributed to 406 Not Acceptable errors during mobile testing
  #
  # SOLUTION:
  # - Disable browser restrictions in development environment
  # - This allows mobile testing with Chrome DevTools while maintaining restrictions in production

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # But disable this restriction in development environment
  allow_browser versions: :modern unless Rails.env.development?

  # Include the locale handling concern
  include SetLocale
end

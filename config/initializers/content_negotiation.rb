# Content Negotiation Fix for Rails Applications
# ==================================
#
# PROBLEM:
# - Rails' strict content negotiation matches Accept headers against formats defined in controllers
# - Chrome DevTools mobile emulation sends Accept headers with application/xhtml+xml format
# - Controllers that only define respond_to format.html cannot handle these requests
# - This results in 406 Not Acceptable errors when testing mobile views
#
# SOLUTION:
# - This initializer adds a monkey patch to Rails' content negotiation system
# - It extends the respond_to method to automatically include HTML format even when not explicitly specified
# - This allows controllers to respond with HTML content even when the Accept header contains complex formats
# - Only applied in development environment to maintain strict content negotiation in production

require "action_controller/metal/mime_responds"

module ActionController
  module MimeResponds
    module ClassOverrides
      def respond_to(*mimes)
        respond_to_block = lambda { |format|
          mimes.each do |mime|
            format.send(mime)
          end
        }

        self.class_eval do
          define_method(:respond_to_with_html_fallback) do
            # Add HTML format automatically if it's not already included
            # This ensures we always respond to HTML even with complex Accept headers
            if !mimes.include?(:html) && request.format.symbol != :html
              respond_to do |format|
                format.html { render }
                instance_exec format, &respond_to_block
              end
            else
              respond_to(&respond_to_block)
            end
          end

          alias_method :respond_to_without_html_fallback, :respond_to
          alias_method :respond_to, :respond_to_with_html_fallback
        end
      end
    end
  end
end

# Only apply this monkey patch in development environment
# This maintains strict content negotiation in production for security and proper API behavior
ActionController::Base.extend(ActionController::MimeResponds::ClassOverrides) if Rails.env.development?

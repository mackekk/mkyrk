module Middleware
  # ContentNegotiationMiddleware addresses the 406 Not Acceptable errors in mobile view
  # 
  # PROBLEM:
  # - Chrome DevTools mobile emulation sends Accept headers containing application/xhtml+xml format
  # - Rails' strict content negotiation sees this format isn't explicitly supported (only HTML is defined in controllers)
  # - This results in 406 Not Acceptable errors when testing mobile views
  #
  # SOLUTION:
  # - This middleware intercepts requests with Accept headers containing application/xhtml+xml
  # - It modifies the header to prioritize text/html first, ensuring Rails returns HTML content
  # - This avoids having to modify every controller to explicitly support all possible formats
  class ContentNegotiationMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # Check if the Accept header contains application/xhtml+xml but doesn't have text/html as first priority
      if env["HTTP_ACCEPT"] && env["HTTP_ACCEPT"].include?("application/xhtml+xml")
        # Prepend text/html with high priority to ensure HTML content is returned
        env["HTTP_ACCEPT"] = "text/html,#{env["HTTP_ACCEPT"]}"
      end

      @app.call(env)
    end
  end
end 
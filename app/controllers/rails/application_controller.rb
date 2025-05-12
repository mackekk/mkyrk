module Rails
  # Special controller for handling Chrome DevTools mobile emulation requests
  #
  # PROBLEM:
  # - Chrome DevTools mobile emulation sends Accept headers with application/xhtml+xml
  # - Regular controllers only define respond_to format.html, causing 406 Not Acceptable errors
  # 
  # SOLUTION:
  # - This controller acts as a catch-all for requests with application/xhtml+xml in Accept header
  # - It explicitly forces HTML format when redirecting back to the same path
  # - This allows mobile testing without modifying all controllers to support every format
  class ApplicationController < ActionController::Base
    # Redirect to the same path but set the format to HTML
    def redirect_to_same_path
      # Simply render the requested page as HTML
      redirect_to request.path, format: :html
    end
  end
end 
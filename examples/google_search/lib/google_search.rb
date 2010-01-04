require 'rubygems'
require 'taza'

module GoogleSearch
  include ForwardInitialization

  class GoogleSearch < ::Taza::Site

    # Sets @browser to be a browser initialized for testing your site.	
    def initialize_browser
      super # configure the browser based on the configuration settings
    end

  end
end

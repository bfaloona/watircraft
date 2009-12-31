require 'rubygems'
require 'taza'

module Search
  include ForwardInitialization

  class Search < ::Taza::Site

    # Sets @browser to be a browser initialized for testing your site.	
    def initialize_browser
      super # configure the browser based on the configuration settings
    end

  end
end

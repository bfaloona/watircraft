require 'rubygems'
require 'taza/page'

module Search
  class HomePage < ::Taza::Page

    url 'http://www.google.com/'
    
    field(:search_textbox){         browser.text_field( :name, 'q')}
    
    element(:privacy_link){         browser.link(       :href, /^\/intl\/.+?\/privacy.html/)}
    
    # appears only when logged in
    element(:left_navigation_div){  browser.div(        :id, 'full_nav')}

  end
end

require 'rubygems'
require 'taza/page'

module GoogleSearch
  class HomePage < ::Taza::Page

    url '/'

    def url_regex
      /google/ # intentionally broad so we can trigger the *_page_identifier below
    end
    
    def lucky_button_page_identifier(browser)
      browser.html.match(/<input name=\"btnI\"/)
    end

    field(:search_textbox){         browser.text_field( :name, 'q')}
    
    element(:google_search_button){ browser.button(     :name, 'btnG')}
    element(:privacy_link){         browser.link(       :href, /^\/intl\/.+?\/privacy.html/)}
    
    # appears only when logged in
    element(:left_navigation_div){  browser.div(        :id, 'full_nav')}

  end
end

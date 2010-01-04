require 'rubygems'
require 'taza/page'

module GoogleSearch
  class ResultsPage < ::Taza::Page

    def url_regex
      /google/ # intentionally broad so we can trigger the *_page_identifier below
    end
    
    def result_links_page_identifier(browser)
      browser.html.match(/<div id=\"res\"/)
    end
    
    field(:search_textbox){         browser.text_field( :name, 'q')}
    
    element(:google_search_button){ browser.button(     :name, 'btnG')}

    element(:previous_page_link){                browser.link(:xpath, "//span[text()='Previous']/..")}
    element(:next_page_link){                browser.link(:xpath, "//span[text()='Next']/..")}
    element(:page_1_link){                browser.link(:xpath, "//span[text()='1']/..")}
    element(:page_2_link){                browser.link(:xpath, "//span[text()='2']/..")}
    element(:page_9_link){                browser.link(:xpath, "//span[text()='9']/..")}
    element(:page_10_link){                browser.link(:xpath, "//span[text()='10']/..")}
  end
end

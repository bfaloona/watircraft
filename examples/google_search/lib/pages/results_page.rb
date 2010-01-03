require 'rubygems'
require 'taza/page'

module GoogleSearch
  class ResultsPage < ::Taza::Page

    element(:previous_page_link){                browser.link(:xpath, "//span[text()='Previous']/..")}
    element(:next_page_link){                browser.link(:xpath, "//span[text()='Next']/..")}
    element(:page_1_link){                browser.link(:xpath, "//span[text()='1']/..")}
    element(:page_2_link){                browser.link(:xpath, "//span[text()='2']/..")}
    element(:page_9_link){                browser.link(:xpath, "//span[text()='9']/..")}
    element(:page_10_link){                browser.link(:xpath, "//span[text()='10']/..")}
  end
end

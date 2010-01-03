require 'spec'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/..')
require 'google_search'

Then /^I search for '(.*?)'$/ do |search_term|
  search(search_term)
  browser.wait
end

Then /^I should find '(.*?)'$/ do |result_term|
  found = false 
  results.each do |text, href|
    found = true if text.match(/#{result_term}/i)
  end
  fail "The text #{result_term} did not appear in the text of any result links" unless found
end

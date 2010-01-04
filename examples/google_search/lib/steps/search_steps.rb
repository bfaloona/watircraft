require 'spec'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/..')
require 'google_search'

Then /^I search for '(.*?)'$/ do |search_term|
  search(search_term)
  browser.wait
end

Then /^I should find '(.*?)'$/ do |result_term|
  fail "The text #{result_term} did not appear in the text of any result links" unless results_include(result_term)
end

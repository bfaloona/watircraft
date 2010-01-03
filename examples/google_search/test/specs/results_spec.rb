$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

describe "Results" do

  it "should have page links" do
    home_page.goto
    search('watircraft') 
    lambda{results_page.previous_page_link.href}.should raise_error
    results_page.next_page_link.href.should match(/\?.*?start=\d\d/)
    results_page.page_2_link.href.should match(/\?.*?start=10&/)
    results_page.page_10_link.href.should match(/\?.*?start=90&/)
  end
  
end
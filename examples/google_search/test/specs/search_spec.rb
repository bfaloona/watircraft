$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

require 'pp'

describe "Search" do

  before :all do
    home_page.goto
  end

  it "should find what I search for" do
    search('watircraft') 
    browser.text.should match(/bret/) 
  end

end
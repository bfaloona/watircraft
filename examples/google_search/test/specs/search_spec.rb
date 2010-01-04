$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'
require 'taza/page'

describe "Search" do

  before :all do
    home_page.goto
  end

  it "should find what I search for" do
    search('watircraft') 
    results_include('bret') 
  end

end
$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

describe "Home Page" do

  it "should display the copyright" do
    browser.text.should match(/©2009/)
  end
  
  it "should have a privacy link" do
    home_page.privacy_link.should exist
  end
  
  it "should not have a left navigation div" do
    # this can be useful to verify that configurable objects do not exist
    home_page.left_navigation_div.should_not exist
  end
  
  it "should have an empty search box" do
    home_page.search_textbox.should == ''
  end
  
  it "should have a search box" do
    # to get the builtin element object of this field
    # reference the _field object
    home_page.search_textbox_field.should be_enabled
  end
  
  
end
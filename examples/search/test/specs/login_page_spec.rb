$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

describe "Login Page" do

  before :all do
    login_page.goto
  end

  
  it "should display the copyright" do
    browser.text.should match(/©#{Time.now.year}\b/)
  end
  
  it "should have a privacy link" do
    login_page.privacy_link.should exist
  end
  
  it "should not have a password error message" do
    login_page.password_error_message.should_not exist
  end
  
  it "should have empty email and password textboxs" do
    login_page.email_textbox.should == ''
    login_page.password_textbox.should == ''
  end
    
  
end
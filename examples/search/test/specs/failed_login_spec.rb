$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

describe "Failed Login" do

  before :each do
    login_page.goto
  end

  
  it "should display an error message when username or password are incorrect" do
    logged_in?.should be_nil
    login('foo', 'bar')
    logged_in?.should be_nil
  end
  
    
  
end
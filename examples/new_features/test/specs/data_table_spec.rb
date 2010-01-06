$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

describe "Data Table Default" do

  before :all do
    test_file = 'file:///' + `pwd` + '/test/artifacts/data_table_default.html'
    browser.goto test_file    
    #
  end
  
  it "should have a data_table" do
    data_table_default_page.data_table.should exist
  end

  it "should count rows" do
    data_table_default_page.row_count.should == 4
  end

  it "should count columns" do
    data_table_default_page.column_count.should == 3
  end

end

describe "Data Table Configured" do

  before :all do
    test_file = 'file:///' + `pwd` + '/test/artifacts/data_table_configured.html'
    browser.goto test_file    
    #
  end

  it "should have a data_table" do
    data_table_configured_page.data_table.should exist
  end

  it "should count rows" do
    data_table_configured_page.row_count.should == 4
  end

  it "should count columns" do
    data_table_configured_page.column_count.should == 3
  end

  it "should return cell data" do
    data_table_configured_page.cell_value(1, 1).should == 'William Shakespeare'
    data_table_configured_page.cell_value(2, 2).should == '44'
    data_table_configured_page.cell_value(4, 3).should == 'May 12, 2010'
  end
  
  it "should return row data" do
    data_table_configured_page.row_values(2).size.should == 3
    data_table_configured_page.row_values(1).should include('William Shakespeare')
  end
  
  it "should return column data" do
    data_table_configured_page.column_values(1).size.should == 4
    data_table_configured_page.column_values(2).should include('44')
  end
  
end
require 'rubygems'
require 'taza/page'

module NewFeatures
  class DataTableDefaultPage < ::Taza::Page

    include DataTable

    def initialize
      super
      setup_data_table
    end    
    
    element(:data_table){         browser.table(:id, 'the_data_table') }
    
  end
end

require 'rubygems'
require 'taza/page'

module NewFeatures
  class DataTableConfiguredPage < ::Taza::Page

    include DataTable

    @@column_name_offsets = {
      :name =>          2,
      :number =>        4,
      :date_time =>     5
    }

    def initialize
      super
      setup_data_table( @@column_name_offsets, 3, 1, [1,3] )
      
    end
        
    element(:data_table){         browser.table(:id, 'the_data_table') }
    
  end
end

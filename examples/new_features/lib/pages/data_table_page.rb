require 'rubygems'
require 'taza/page'

module NewFeatures
  class DataTablePage < ::Taza::Page

    include DataTable
    
    def initialize
      super
      setup_data_table
    end
    
    def setup_data_table
      @first_row_offset = 3
      @ignore_last_rows = 1
      @ignored_column_offsets = [1,3]
      # specify offset of column names
      @column_name_offsets = {
        :name =>          2,
        :number =>        4,
        :date_time =>     5
      }      
    end
    
    element(:data_table){         browser.table(:id, 'the_data_table') }
    
  end
end

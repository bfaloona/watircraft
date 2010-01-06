module NewFeatures
  # = Description
  # Include this module on Page files that contain a single table showing rows of data
  # * offsets are 1 based references to HTML table column/row
  # * nums are 1 based refereces to visible data table column/row
  # * data table columns have column headers and contain text (not icons)
  # * <tt>@column_name_offsets</tt> allow for named refereces to columns
  # 
  # = Requirements
  # * html table must be defined as <tt>element(:data_table){...}</tt>
  # * instance variable configuration
  #
  #   <tt>@first_row_offset</tt>::         (optional) offset of the first row containing data. defaults to 1
  #   <tt>@ignore_last_rows</tt>::         (optional) number of rows to ignore at the bottom of the table.
  #                                        defaults to 0
  #   <tt>@ignored_column_offsets</tt>::   (optional) array of html column offsets to ignore.
  #                                        use this to implement this requirement:
  #                                        "data table columns have column headers and contain text (not icons)"
  #   <tt>@column_name_offsets</tt>::      (optional) hash that allows names (keys) to be assigned to column offsets (values).
  #                                        for example:
  #       @column_name_offsets = {
  #         :favorite =>      2,
  #         :type =>          3,
  #         :node =>          4,
  #         :gl_code =>       5,
  #         :account =>       Proc.new{ self.column_count > 9 ? 6 : nil},
  #         :service =>       Proc.new{ self.column_count > 10 ? 7 : nil},
  #         :description1 =>  Proc.new{ case self.column_count
  #                                     when 9 then 6
  #                                     when 10 then 7
  #                                     else 8
  #                                     end
  #                                   }
  #       }
  #
  # =Features
  # * lookup by column name. for example: <tt>data_table_column('Service')</tt>
  # * interaction with a row's checkbox or option. for example: <tt>data_table_select_item(3)</tt>
  # * convinience methods like <tt>data_table_row_count</tt>
  #
  # =Notes
  # * The use of watircraft tables (<tt>table(:data){...}</tt>) declarations are currently not working (BFF - Dec 11 2009)
  
  module DataTable
    
    def setup_data_table( column_name_offsets={}, first_row_offset=2, ignore_last_rows=0, ignored_column_offsets=[] )
      @column_name_offsets = column_name_offsets      
      @first_row_offset = first_row_offset
      @ignore_last_rows = ignore_last_rows
      @ignored_column_offsets = ignored_column_offsets
    end

    def watir_table
      @watir_table = @watir_table || self.data_table
    end

    def number_of_cells
      watir_table.row_values(@first_row_offset).size
    end

    def column_offsets
      offsets = []
      1.upto(number_of_cells) do |offset|
        offsets << offset unless @ignored_column_offsets.include?( offset )
      end
      if @ignored_column_offsets.include?(-1)
        offsets.slice!(-1)
      end
      if @ignored_column_offsets.include?(-2)
        raise ArgumentError, "-2 is unsupported in @ignored_column_offsets"
      end
      return offsets
    end

    def header_links
      links = []
      cells = filtered_by_column_offsets(row_object(@first_row_offset - 1))
      cells.each do |cell|
        links << cell.link(:index,1) rescue nil
      end
      links
    end

    def row_values(num)
      values = watir_table.row_values( row_offset(num) )
      filtered_by_column_offsets(values)
    end

    def filtered_by_column_offsets( array )
      # given all row values/objects from html table, return columns we care about
      results = []
      index = 0
      offsets = column_offsets
      array.each do |i|
        results << i if offsets.include?(index + 1)
        index += 1
      end
      results
    end

    def resolve_column_number(identifier)
      identifier.to_s.match(/^\d+$/) ? identifier.to_i : column_num_from_name(identifier)
    end

    def column_values(column)
      num = resolve_column_number(column)
      values = []
      1.upto(row_count) do |index|
        values << cell_value(index, num)
      end
      values
    end

    def row_count
      ignored_rows = @ignore_last_rows + (@first_row_offset - 1)
      begin
        if site.config[:browser] == 'ie'
          total_rows = watir_table.row_count_excluding_nested_tables
        else
          total_rows = watir_table.row_count
        end
        count = total_rows - ignored_rows
      rescue Watir::Exception::UnknownObjectException => e
        count = 0
      end
      return count < 0 ? 0 : count
    end

    def column_count
      column_offsets.size
    end

    def headers
      row_values(0)
    end

    def header(num)
      headers[num.to_i - 1]
    end

    def cell_value(row_num, column_num)
      row_values(row_num.to_i)[column_num.to_i - 1]
    end

    def column_num_from_name(column_name)
      if @column_name_offsets
        offset_obj = @column_name_offsets[column_name.to_s.computerize.to_sym]
        if offset_obj.respond_to? :call
          column_number( offset_obj.call )
        else
          column_number( offset_obj.to_i )
        end
      else
        if column_name.class == Symbol
          headers.map{|h| h.computerize.to_sym}.index( column_name ) + 1
        elsif column_name.class == String
          headers.index( column_name ) + 1
        else
          raise ArgumentError, "Unsupported data type for column_name: #{column_name}"
        end
      end
    end

    def column_name_from_num(num)
      headers[num.to_i - 1]
    end

    def row_object(offset)
      watir_table[offset.to_i]
    end

    def column_number(offset)
      raise "Unsupported" unless offset.to_s.match(/^\d+$/)
      column_offsets.index(offset.to_i) + 1
    end

    def column_offset(column)
      if column.to_s.match(/^\d+$/)
        column_num = column.to_i
        column_offsets[column_num - 1]
      else
        raise "Unimplemented"
      end
    end

    def row_offset(row_num)
      row_num.to_i + @first_row_offset - 1
    end
    
    ########
    # Select
    ########
        
    def data_table_select_item(selector)
      if selector.kind_of? Hash
        selection_value = selector[:value]
        if selector[:name].to_s.match(/^\d+$/)
          selection_column_name = column_name_from_num( selector[:name].computerize.to_sym )
        else
          selection_column_name = selector[:name].computerize.to_sym
        end
        if self.respond_to? :data
          begin
            self.data.row(selection_column_name => selection_value).checkbox.set
          rescue Watir::Exception::UnknownObjectException, NoMethodError => e
            self.data.row(selection_column_name => selection_value).option.set rescue raise RuntimeError, "Unable to select row using 'checkbox' or 'option' element for column #{selection_column_name} and value #{selection_value}"
          end
        else
          col_values = column_values(selection_column_name)
          row_number = 1
          col_values.each do |column_value|
            break if column_value == selection_value.to_s
            row_number += 1
            if row_number > col_values.size
              raise RuntimeError, "Unable to select data table item based on column: #{selection_column_name}"
            end
          end
          data_table_select_item(row_number)
        end
      elsif selector.respond_to? :to_i
        num = selector.to_i
        begin
          row = row_object( row_offset(num) )
          row.checkbox(:index, 1).set
        rescue Watir::Exception::UnknownObjectException, NoMethodError => e
          row.radio(:index, 1).set rescue raise RuntimeError, "Unable to select row using watir checkbox or radio"
        end
      else
        raise ArgumentError, "Expected selector to be a Hash or a number"
      end
    end

    def data_table_row_selected(num)
        begin
          row = row_object( row_offset(num) )
          row.checkbox(:index, 1).checked?
        rescue Watir::Exception::UnknownObjectException, NoMethodError => e
          row.radio(:index, 1).checked? rescue raise RuntimeError, "Unable to select row using watir checkbox or radio"
        end
    end
 
    #######
    # Sort
    #######
    def data_table_sort_column(column, direction=nil)
      column_num = resolve_column_number(column)
      if direction
        currentDirection = data_table_column_sort_indicator(column_num)
        if currentDirection == direction
          return nil
        end
      end
      link = header_links[column_num - 1]
      if link.nil?
        return nil
      else
        begin
          link.click
        rescue Watir::Exception::UnknownObjectException => e
          # no sort link found
          return nil
        end
      end     
    end 
   
    alias :data_table_row_count     :row_count
    alias :number_of_items          :row_count
    alias :rows                     :row_count
    alias :data_table_row           :row_values

    alias :data_table_column        :column_values
    alias :data_table_column_count  :column_count
    alias :col_num_from_name        :column_num_from_name
    alias :col_name_from_num        :column_name_from_num

    alias :data_table_headers       :headers
    alias :data_table_header        :header
    
  end
end
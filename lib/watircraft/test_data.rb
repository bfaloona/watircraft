module WatirCraft
  
  class KeyNotFound < Exception; end
  
  # Draft Implementation - Originally written by Bret Pettichord
  #
  # Assumptions
  # - OpenOffice
  # - Data is stored in columns
  # - First row is the "name" of the data set/record
  # - Each sheet must specify delimiter value in ARRAY_DELIMITER_VARIABLE variable
  class TestData
    ARRAY_DELIMITER_DEFAULT = "\n"
    ARRAY_DELIMITER_VARIABLE = 'list_delimiter'
    def initialize params
      @spreadsheet = Openoffice.new params[:file]
      @spreadsheet.default_sheet = params[:sheet]
      @raw_keys = @spreadsheet.column(@spreadsheet.first_column)
      this_column = ((@spreadsheet.first_column + 1)..(@spreadsheet.last_column)).detect do |column|
        @spreadsheet.cell(@spreadsheet.first_row, column) == params[:name]
      end
      @raw_values = @spreadsheet.column(this_column)
      self.each do |k, v|
        if k == ARRAY_DELIMITER_VARIABLE.computerize.to_sym
          if v.nil? or v.empty?
            v = ARRAY_DELIMITER_DEFAULT
          end
          @delimiter = v
        end
      end
      if @delimiter.nil?
        raise ArgumentError, "Spreadsheet sheet must specify delimiter value in '#{ARRAY_DELIMITER_VARIABLE}' variable"
      end
    end
    def keys
      @keys ||= @raw_keys.map {|k| k.computerize.to_sym}
    end
    def [] key
      index = keys.index key
      raise KeyNotFound, "Key #{key} not found" if index.nil?
      value index
    end
    def each
      keys.each_with_index {|k, i| yield k, value(i)}
    end
    private
    def value index
      if @delimiter and @raw_values[index].to_s.include? @delimiter
        # value is an array
        Array.new(@raw_values[index].to_s.split(@delimiter))
      else
        @raw_values[index].to_s
      end
    end
    
  end
end
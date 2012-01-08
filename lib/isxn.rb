# isxn.rb
#
# a module that provides validation and helper methods for ISBN and ISSN numbers

module Isxn
  class CIsxn
    attr_reader :format, :err

    ReIsbn10 = /^(?:\d[\ |-]?){9}[\d|X]$/
    ReIsbn13 = /^(?:\d[\ |-]?){13}$/
    ReIssn = /^(?:\d[\ |-]?){7}[\d|X]$/

    CheckCode = {
      :isbn_10 => [10, 9, 8, 7, 6, 5, 4, 3, 2],
      :isbn_13 => [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3],
      :issn => [8, 7, 6, 5, 4, 3, 2]}

    CheckMod = {:isbn_10 => 11, :isbn_13 => 10, :issn => 11}

    def initialize(str)
      @err = nil
      @isxn = str.strip.upcase
      verify_and_extract
    end

    def valid?
      @err.nil?
    end

    # Takes an ISxN string and returns an array of integers of its numerical values
    def to_a
      @numbers
    end

    # For ISBN or unknown format: returns the cleaned up input string
    # For ISSN: returns the official string for the ISSN number if valid - else the cleaned up input string
    # For unknown format: 
    def to_s(force = false)
      if @format == :issn
        # making use of fixed grouping for ISSN to return a standardised format
        @err ? @isxn : "#{@numbers[0, 4].join}-#{@numbers[4, 3].join}#{check_str(@numbers[7])}"
      else
        @isxn
      end
    end

    private
    # Automatically determine format.
    # Sets @format to one of :issn, :isbn_10, :isbn_13 or nil
    # If @format is not nil, the @numbers array is filled with the numerical values of the code
    # If @format is nil, the @err variable is set to either :unknown_format or :bad_checksum
    def verify_and_extract
      values = @isxn.gsub(/\ |-/, '').split('')
      values[-1] = 10 if values.last == 'X'
      @numbers = values.map {|v| v.to_i}

      if @isxn =~ ReIsbn10
        @format = :isbn_10
      elsif @isxn =~ ReIsbn13
        @format = :isbn_13
      elsif @isxn =~ ReIssn
        @format = :issn
      else
        @numbers = []
        @format = nil
        @err = :unknown_format
      end

      if @format
        checksum = CheckCode[@format].zip(@numbers[0..-2]).inject(0) {|s, (u, v)| s + u * v}
        if (checksum + @numbers.last) % CheckMod[@format] != 0
          @err = :bad_checksum
        end
      end
    end

    def check_str(val)
      val < 10 ? val.to_s : "X"
    end
  end
end

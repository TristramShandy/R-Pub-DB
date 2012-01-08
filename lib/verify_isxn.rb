# verify_isxn.rb
#
# a module that provides validation and helper methods for ISBN and ISSN numbers

module VerifyIsxn
  class Isxn
    attr_reader :format, :err

    def initialize(str)
      @err = nil
      verify_and_extract(str)
    end

    def valid?
      ! @format.nil?
    end

    # Takes an ISxN string and returns an array of integers of its numerical values
    def to_a
      @numbers
    end

    # Returns the official string for the ISxN number
    def to_s
      case @format
      when :issn
        "#{@numbers[0, 4].join}-#{@numbers[4, 3].join}#{check_str(@numbers[7])}"
      when :isbn_10
        "#{@numbers[0, 4].join}-#{@numbers[4, 3].join}#{check_str(@numbers[7])}"
    end

    private
    # Automatically determine format.
    # Sets @format to one of :issn, :isbn_10, :isbn_13 or nil
    # If @format is not nil, the @numbers array is filled with the numerical values of the code
    # If @format is nil, the @err variable is set to either :unknown_format or :bad_checksum
    def verify_and_extract
    end

    def check_str(val)
      val < 10 ? val.to_s : "X"
    end
  end
end

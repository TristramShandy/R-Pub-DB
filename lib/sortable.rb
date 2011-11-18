# sortable.rb
#
# a module that provides methods for sortable items

module Sortable
  # Info on displayed headers.
  # sortable and filterable are supposed to be integers that are defined below
  #   They can take one of three values: C_No, C_Yes, C_Default
  HeaderInfo = Struct.new(:name, :attribute, :sortable, :filterable)

  C_No = 0
  C_Yes = 1
  C_Default = 2

  class HeaderInfo
    # What to display in the table
    def show(item)
      if attribute == :scope
        "XXX" # TODO: implement
      else
        item[attribute].to_s
      end
    end

    def is_sortable?
      sortable == C_Yes || sortable == C_Default
    end
  end

  # SortableItem holds information on the item to display
  class Item
    def initialize(item)
      @item = item
    end

  end

  # main class: a collection of items with information on sortability
  class List
    attr_reader :headers, :items, :sort, :direction, :table_name

    def initialize(klass, params)
      @table_name = klass.table_name
      @headers = klass.const_get(:DisplayInfo)

      @direction = (['asc', 'desc'].include?(params[:direction]) ? params[:direction].to_sym : :asc)

      @sort = params[:sort].to_s.to_sym
      found = false

      # Iterate through headers to check if @sort is an allowable column and find default values
      @headers.each do |a_header|
        @default_sort = a_header if a_header.sortable == C_Default
        @default_filter = a_header if a_header.filterable == C_Default
        found ||= (@sort == a_header.attribute && a_header.is_sortable?)
      end
      @sort = @default_sort.attribute unless found

      if @sort == :scope
        # special treatment for scope necessary, as it is a combination of different attributes
        # TODO: implement sorting
        @items = klass.find(:all)
      else
        @items = klass.order("#{@sort} #{@direction}")
      end
    end
  end
end

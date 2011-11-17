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

  # SortableItem holds information on the item to display
  class Item
    def initialize(item)
      @item = item
    end

    # What to display in the table
    def show
      @item.to_s
    end
  end

  # main class: a collection of items with information on sortability
  class List
    attr_reader :headers, :items

    def initialize(raw_items, header_info)
      @items = raw_items.map {|item| Item.new(item)}
      @headers = header_info
    end
  end
end
